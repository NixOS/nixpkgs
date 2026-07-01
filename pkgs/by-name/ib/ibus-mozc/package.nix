{
  lib,
  qt6,
  pkg-config,
  ibus,
  unzip,
  python3,
  libglvnd,
  libxcrypt-legacy,
  glib,
  stdenv,
  writableTmpDirAsHomeHook,
  lndir,
  makeDesktopItem,
  copyDesktopItems,
  mozc,
}:
let
  pname = "ibus-mozc";
  inherit (mozc)
    version
    src
    bazel
    bazelPythonPatch
    ;

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

  bazelArgs = [
    "--config=oss_linux"
    "--config=stable_channel"
    "--config=release_build"
    "--action_env=C_INCLUDE_PATH=${includePath}"
    "--action_env=CPLUS_INCLUDE_PATH=${includePath}"
    "--action_env=LIBRARY_PATH=${libraryPath}"
    "renderer/qt:mozc_renderer"
    "unix/ibus:ibus_mozc"
  ];

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

      hash = "sha256-5ZU490czheaya7KB7twcIbzZMlzcwVmV68j9upyItHk=";
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

        bazel vendor --lockfile_mode=update --vendor_dir="$out/vendor_dir" ${lib.escapeShellArgs bazelArgs}
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
      --replace-fail "/usr/lib/mozc" "${mozc}/lib/mozc" \
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
  '';

  buildPhase = ''
    runHook preBuild

    bazel build --lockfile_mode=error --vendor_dir=vendor_dir ${lib.escapeShellArgs bazelArgs}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm555 bazel-bin/renderer/qt/mozc_renderer "$out/lib/mozc/mozc_renderer"
    install -Dm555 bazel-bin/unix/ibus/ibus_mozc       "$out/lib/ibus-mozc/ibus-engine-mozc"
    install -Dm555 bazel-bin/unix/ibus/mozc.xml        "$out/share/ibus/component/mozc.xml"

    unzip bazel-bin/unix/icons.zip -d "$out/share/ibus-mozc/"

    runHook postInstall
  '';

  # create a desktop file for gnome-control-center
  # contents copied from ubuntu
  desktopItems = [
    (makeDesktopItem {
      name = "ibus-setup-mozc-jp";
      desktopName = "Mozc Setup";
      exec = "${mozc}/lib/mozc/mozc_tool --mode=config_dialog";
      type = "Application";
      startupNotify = true;
      noDisplay = true;
    })
  ];

  passthru = {
    inherit vendorDeps;
  };
  meta = {
    isIbusEngine = true;
    description = "Japanese input method from Google";
    homepage = "https://github.com/google/mozc";
    license = lib.licenses.free;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      pineapplehunter
    ];
  };
}
