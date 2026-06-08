{
  lib,
  fetchFromGitHub,
  qt6,
  pkg-config,
  bazel_8,
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
  bazel = bazel_8;

  ut-dictionary = merge-ut-dictionaries.override { inherit dictionaries; };

  pname = "mozc";
  version = "3.33.6133";

  src = fetchFromGitHub {
    owner = "google";
    repo = "mozc";
    tag = version;
    hash = "sha256-4ZrCIWoqYjoBwaoXq2QGajIQgWP0m2V3ozWQhZIq138=";
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

  bazelArgs =
    vendor:
    [
      "--config=oss_linux"
      "--config=stable_channel"
      "--config=release_build"
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

  bazelPythonPatch = ''
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

  # vendoring: run "bazel vendor" to download all external dependencies,
  # then clean up sandbox-specific symlinks and markers so the output
  # is reproducible (fixed-output derivation).
  vendorDeps = stdenv.mkDerivation (
    lib.fetchers.normalizeHash { } {
      pname = "${pname}-vendor";
      inherit
        src
        version
        nativeBuildInputs
        buildInputs
        ;

      hash = "sha256-N0Ohx6rojZsHbK+aLfwsZ5PRhBF/T4NqbVc/keQ/ZH4=";
      outputHashMode = "recursive";

      strictDeps = true;
      __structuredAttrs = true;

      env.USE_BAZEL_VERSION = bazel.version;

      buildPhase = ''
        runHook preBuild

        cd src

        cat >> MODULE.bazel << EOF
        ${bazelPythonPatch}
        EOF

        bazel vendor --lockfile_mode=update --vendor_dir="$out/vendor_dir" ${lib.escapeShellArgs (bazelArgs true)}
        cp MODULE.bazel.lock "$out"

        echo "removing broken symlinks and markers..."
        find "$out" -type l -lname '/*' -print -delete
        find "$out" -xtype l -print -delete
        rm -vrf "$out"/vendor_dir/*local_python3*

        runHook postBuild
      '';
      dontInstall = true;
      dontFixup = true;
      dontWrapQtApps = true;
    }
  );
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

    cat >> MODULE.bazel << EOF
    ${bazelPythonPatch}
    EOF

    substituteInPlace config.bzl \
      --replace-fail "/usr/bin/xdg-open" "${xdg-utils}/bin/xdg-open" \
      --replace-fail "/usr" "$out"

    cp -r --no-preserve=mode "${vendorDeps}"/* .
    substituteInPlace \
      vendor_dir/rules_python*/python/private/py_runtime_info.bzl \
      vendor_dir/rules_python*/python/private/py_executable.bzl \
      vendor_dir/rules_python*/python/private/runtime_env_toolchain.bzl \
      --replace-fail "/usr/bin/env python3" "${lib.getExe python3}"
    patchShebangs --build vendor_dir
    for dir in vendor_dir/*/; do
      echo "pin(\"@@$(basename "$dir")\")"
    done > vendor_dir/VENDOR.bazel
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

    install -Dm555 "bazel-bin/server/mozc_server"           "$out/lib/mozc/mozc_server"
    install -Dm555 "bazel-bin/gui/tool/mozc_tool"           "$out/lib/mozc/mozc_tool"
    install -Dm555 "bazel-bin/unix/emacs/mozc_emacs_helper" "$out/bin/mozc_emacs_helper"
    install -Dm444 "unix/emacs/mozc.el"                     "$out/share/emacs/site-lisp/emacs-mozc/mozc.el"
  ''
  + (lib.optionalString withIbus ''
    install -Dm555 "bazel-bin/renderer/qt/mozc_renderer"    "$out/lib/mozc/mozc_renderer"
    install -Dm555 "bazel-bin/unix/ibus/ibus_mozc"          "$out/lib/ibus-mozc/ibus-engine-mozc"
    install -Dm555 "bazel-bin/unix/ibus/mozc.xml"           "$out/share/ibus/component/mozc.xml"

    unzip bazel-bin/unix/icons.zip -d "$out/share/ibus-mozc/"
  '')
  + ''
    runHook postInstall
  '';

  # create a desktop file for gnome-control-center
  # contents copied from ubuntu
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
    inherit vendorDeps bazel bazelPythonPatch;
  };
  meta = {
    isIbusEngine = withIbus;
    description = "Japanese input method from Google";
    mainProgram = "mozc_emacs_helper";
    homepage = "https://github.com/google/mozc";
    license = lib.licenses.free;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      pineapplehunter
    ];
  };
}
