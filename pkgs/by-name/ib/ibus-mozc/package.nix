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
    bazelCommonArgs
    mkVendorDeps
    setupBazelVendor
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

  bazelArgs = bazelCommonArgs ++ [
    "--action_env=C_INCLUDE_PATH=${includePath}"
    "--action_env=CPLUS_INCLUDE_PATH=${includePath}"
    "--action_env=LIBRARY_PATH=${libraryPath}"
    "renderer/qt:mozc_renderer"
    "unix/ibus:ibus_mozc"
  ];

  vendorDeps = mkVendorDeps {
    inherit
      pname
      src
      version
      nativeBuildInputs
      buildInputs
      bazelArgs
      ;
    hash = "sha256-l3J2LyB95Scdz9GLC0YrPXg01jJK60woHVm3AdYQ31w=";
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
      --replace-fail "/usr/lib/mozc" "${mozc}/lib/mozc" \
      --replace-fail "/usr" "$out"
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
    install -Dm444 data/images/product_icon_32bpp-128.png "$out/share/ibus-mozc/product_icon.png"
    install -Dm444 data/images/icon.svg "$out/share/ibus-mozc/product_icon.svg"
    install -Dm444 ../LICENSE "$out/share/licenses/$pname/LICENSE"

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
