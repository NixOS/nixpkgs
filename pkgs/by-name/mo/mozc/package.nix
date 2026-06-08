{
  lib,
  fetchFromGitHub,
  qt6,
  pkg-config,
  bazel_9,
  ibus,
  unzip,
  xdg-utils,
  python3,
  libglvnd,
  libxcrypt-legacy,
  glib,
  stdenv,
  writableTmpDirAsHomeHook,
  lndir,
  makeDesktopItem,
  copyDesktopItems,

  withIbus ? false,

  dictionaries ? [ ],
  merge-ut-dictionaries,
}:
let
  bazel = bazel_9;

  ut-dictionary = merge-ut-dictionaries.override { inherit dictionaries; };

  pname = "mozc";
  version = "3.34.6239";

  src = fetchFromGitHub {
    owner = "google";
    repo = "mozc";
    tag = version;
    hash = "sha256-m7hxJafQVXIaV3l6s5Xix8liXf4NN18Jwv0CzTrdYqM=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    bazel
    copyDesktopItems
    lndir
    pkg-config
    python3
    qt6.wrapQtAppsHook
    unzip
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    glib
    ibus
    libglvnd
    libxcrypt-legacy
    qt6.qtbase
  ];

  includePath = lib.makeIncludePath buildInputs;
  libraryPath = lib.makeLibraryPath buildInputs;

  bazelCommonArgs = [
    "--config=oss_linux"
    "--config=stable_channel"
    "--config=release_build"
    # Build protoc from source instead of downloading a host-platform binary.
    "--@com_google_protobuf//bazel/flags:prefer_prebuilt_protoc=false"
  ];

  bazelArgs =
    vendor:
    bazelCommonArgs
    ++ [
      "--action_env=C_INCLUDE_PATH=${includePath}"
      "--action_env=CPLUS_INCLUDE_PATH=${includePath}"
      "--action_env=LIBRARY_PATH=${libraryPath}"
      "gui/tool:mozc_tool"
      "server:mozc_server"
      "unix/emacs:mozc_emacs_helper"
    ]
    ++ lib.optionals (vendor || withIbus) [
      "renderer/qt:mozc_renderer"
      "unix/ibus:ibus_mozc"
    ];

  bazelPythonConfig = ''
    local_runtime_repo = use_repo_rule(
        "@rules_python//python/local_toolchains:repos.bzl",
        "local_runtime_repo",
    )
    local_runtime_toolchains_repo = use_repo_rule(
        "@rules_python//python/local_toolchains:repos.bzl",
        "local_runtime_toolchains_repo",
    )

    local_runtime_repo(
        name = "local_python3",
        interpreter_path = "python3",
        on_failure = "fail",
    )

    local_runtime_toolchains_repo(
        name = "local_toolchains",
        runtimes = ["local_python3"],
    )

    register_toolchains("@local_toolchains//:all")
  '';

  # Run `bazel vendor`, then remove host-local Python repositories and
  # sandbox-specific symlinks to keep the fixed output platform-independent.
  mkVendorDeps =
    {
      pname,
      src,
      version,
      nativeBuildInputs,
      buildInputs,
      bazelArgs,
      hash,
    }:
    stdenv.mkDerivation (
      lib.fetchers.normalizeHash { } {
        pname = "${pname}-vendor";
        inherit
          src
          version
          nativeBuildInputs
          buildInputs
          hash
          ;
        outputHashMode = "recursive";

        strictDeps = true;
        __structuredAttrs = true;

        env.USE_BAZEL_VERSION = bazel.version;

        buildPhase = ''
          runHook preBuild

          cd src

          cat >> MODULE.bazel << EOF
          ${bazelPythonConfig}
          EOF

          bazel vendor --lockfile_mode=update --vendor_dir="$out/vendor_dir" ${lib.escapeShellArgs bazelArgs}
          cp MODULE.bazel.lock "$out"

          echo "removing platform-specific repository metadata..."
          find "$out" -type l -lname '/*' -print -delete
          find "$out" -xtype l -print -delete
          find "$out/vendor_dir" -maxdepth 1 -type f -name '*.marker' -print -delete
          rm -vrf \
            "$out"/vendor_dir/*local_python3* \
            "$out"/vendor_dir/*go_sdk+go_toolchains*

          runHook postBuild
        '';
        dontInstall = true;
        dontFixup = true;
        dontWrapQtApps = true;
      }
    );

  setupBazelVendor = vendorDeps: ''
    cat >> MODULE.bazel << EOF
    ${bazelPythonConfig}
    EOF

    cp -r "${vendorDeps}"/* .
    chmod -R u+w vendor_dir
    # The local runtime otherwise generates scripts with /usr/bin/env shebangs.
    substituteInPlace vendor_dir/rules_python*/python/private/local_runtime_repo_setup.bzl \
      --replace-fail 'interpreter_path = interpreter_path,' \
        'interpreter_path = interpreter_path, stub_shebang = "#!${lib.getExe python3}",'
    patchShebangs --build vendor_dir
    for dir in vendor_dir/*/; do
      echo "pin(\"@@$(basename "$dir")\")"
    done > vendor_dir/VENDOR.bazel
  '';

  vendorDeps = mkVendorDeps {
    inherit
      pname
      src
      version
      nativeBuildInputs
      buildInputs
      ;
    bazelArgs = bazelArgs true;
    hash = "sha256-PDpQgTHcs9YE/HpSkMEsUPdQT3mxun058bVghjccAZ4=";
  };
in
stdenv.mkDerivation {
  inherit
    pname
    version
    src
    nativeBuildInputs
    buildInputs
    ;

  strictDeps = true;
  __structuredAttrs = true;

  env.USE_BAZEL_VERSION = bazel.version;

  postPatch = ''
    cd src

    ${setupBazelVendor vendorDeps}

    substituteInPlace config.bzl \
      --replace-fail "/usr/bin/xdg-open" "${xdg-utils}/bin/xdg-open" \
      --replace-fail "/usr" "$out"
  ''
  + lib.optionalString (dictionaries != [ ]) ''
    cat ${ut-dictionary}/mozcdic-ut.txt >> data/dictionary_oss/dictionary00.txt
  '';

  buildPhase = ''
    runHook preBuild

    bazel build --lockfile_mode=error --vendor_dir=vendor_dir ${lib.escapeShellArgs (bazelArgs false)}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm555 bazel-bin/server/mozc_server "$out/lib/mozc/mozc_server"
    install -Dm555 bazel-bin/gui/tool/mozc_tool "$out/lib/mozc/mozc_tool"
    install -Dm555 bazel-bin/unix/emacs/mozc_emacs_helper "$out/bin/mozc_emacs_helper"
    install -Dm444 unix/emacs/mozc.el "$out/share/emacs/site-lisp/emacs-mozc/mozc.el"
  ''
  + lib.optionalString withIbus ''
    install -Dm555 bazel-bin/renderer/qt/mozc_renderer "$out/lib/mozc/mozc_renderer"
    install -Dm555 bazel-bin/unix/ibus/ibus_mozc "$out/lib/ibus-mozc/ibus-engine-mozc"
    install -Dm555 bazel-bin/unix/ibus/mozc.xml "$out/share/ibus/component/mozc.xml"

    unzip bazel-bin/unix/icons.zip -d "$out/share/ibus-mozc/"
    install -Dm444 data/images/product_icon_32bpp-128.png "$out/share/ibus-mozc/product_icon.png"
    install -Dm444 data/images/icon.svg "$out/share/ibus-mozc/product_icon.svg"
  ''
  + ''
    install -Dm444 ../LICENSE "$out/share/licenses/$pname/LICENSE"

    runHook postInstall
  '';

  desktopItems = lib.optionals withIbus [
    (makeDesktopItem {
      name = "ibus-setup-mozc-jp";
      desktopName = "Mozc Setup";
      exec = "@out@/lib/mozc/mozc_tool --mode=config_dialog";
      type = "Application";
      startupNotify = true;
      noDisplay = true;
    })
  ];

  postFixup = lib.optionalString withIbus ''
    substituteInPlace "$out/share/applications/ibus-setup-mozc-jp.desktop" \
      --subst-var out
  '';

  passthru = {
    inherit
      vendorDeps
      bazel
      bazelCommonArgs
      mkVendorDeps
      setupBazelVendor
      ;
  };
  meta = {
    isIbusEngine = withIbus;
    description = "Japanese input method from Google";
    mainProgram = "mozc_emacs_helper";
    homepage = "https://github.com/google/mozc";
    changelog = "https://github.com/google/mozc/releases/tag/${version}";
    license = lib.licenses.free;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      pineapplehunter
    ];
  };
}
