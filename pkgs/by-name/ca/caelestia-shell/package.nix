{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
  makeWrapper,
  makeFontsConf,
  fish,
  ddcutil,
  brightnessctl,
  networkmanager,
  lm_sensors,
  swappy,
  wl-clipboard,
  libqalculate,
  bash,
  hyprland,
  material-symbols,
  rubik,
  nerd-fonts,
  qt6,
  quickshell,
  aubio,
  libcava,
  fftw,
  pipewire,
  xkeyboard-config,
  cmake,
  ninja,
  pkg-config,
  caelestia-cli,
  debug ? false,
  withCli ? true,
}:
let
  version = "2.4.0";
  rev = "24aa15eefdb146350d2548c0a015b04eddbd1008";

  m3shapes_src = fetchFromGitHub {
    owner = "soramanew";
    repo = "m3shapes";
    rev = "32ad9ce328bb77ed349b40a3be10ee9ea610b8ab";
    hash = "sha256-YZelgEZflFNwGutX4/tIzBdbOeghJgE2oDw0uWYGxns=";
  };

  runtimeDeps = [
    fish
    ddcutil
    brightnessctl
    networkmanager
    lm_sensors
    swappy
    wl-clipboard
    libqalculate
    bash
    hyprland
  ]
  ++ lib.optional withCli caelestia-cli;

  fontconfig = makeFontsConf {
    fontDirectories = [
      material-symbols
      rubik
      nerd-fonts.caskaydia-cove
    ];
  };

  cmakeBuildType = if debug then "Debug" else "RelWithDebInfo";

  cmakeVersionFlags = [
    (lib.cmakeFeature "VERSION" version)
    (lib.cmakeFeature "GIT_REVISION" rev)
    (lib.cmakeFeature "DISTRIBUTOR" "nixpkgs")
  ];

  shellSrc = fetchurl {
    url = "https://github.com/caelestia-dots/shell/releases/download/v${version}/caelestia-shell-v${version}.tar.gz";
    hash = "sha256-r3SRcn/zBplpgVD598GGCJzNFxpQne8zK8uh3hyzF3E=";
  };

  extras = stdenv.mkDerivation {
    inherit cmakeBuildType;
    name = "caelestia-extras";
    src = shellSrc;

    nativeBuildInputs = [
      cmake
      ninja
    ];

    cmakeFlags = [
      (lib.cmakeFeature "ENABLE_MODULES" "extras")
      (lib.cmakeFeature "INSTALL_LIBDIR" "${placeholder "out"}/lib")
    ]
    ++ cmakeVersionFlags;
  };

  plugin = stdenv.mkDerivation {
    inherit cmakeBuildType;
    name = "caelestia-qml-plugin";
    src = shellSrc;

    nativeBuildInputs = [
      cmake
      ninja
      pkg-config
    ];
    buildInputs = [
      qt6.qtbase
      qt6.qtdeclarative
      qt6.qtshadertools
      libqalculate
      pipewire
      aubio
      libcava
      fftw
      lm_sensors
    ];

    dontWrapQtApps = true;
    cmakeFlags = [
      (lib.cmakeFeature "ENABLE_MODULES" "plugin")
      (lib.cmakeFeature "INSTALL_QMLDIR" qt6.qtbase.qtQmlPrefix)
    ]
    ++ cmakeVersionFlags;
  };

  m3shapesModule = stdenv.mkDerivation {
    inherit cmakeBuildType;
    name = "caelestia-m3shapes";
    src = m3shapes_src;

    nativeBuildInputs = [
      cmake
      ninja
    ];
    buildInputs = [
      qt6.qtbase
      qt6.qtdeclarative
      qt6.qtshadertools
    ];

    dontWrapQtApps = true;
    cmakeFlags = [
      (lib.cmakeFeature "INSTALL_QMLDIR" qt6.qtbase.qtQmlPrefix)
    ];
  };

in
stdenv.mkDerivation {
  inherit version cmakeBuildType;
  pname = "caelestia-shell";
  __structuredAttrs = true;
  strictDeps = true;
  src = shellSrc;

  nativeBuildInputs = [
    cmake
    ninja
    makeWrapper
    qt6.wrapQtAppsHook
  ];
  buildInputs = [
    quickshell
    extras
    plugin
    m3shapesModule
    xkeyboard-config
    qt6.qtbase
    qt6.qtimageformats
  ];

  cmakeFlags = [
    (lib.cmakeFeature "ENABLE_MODULES" "shell")
    (lib.cmakeFeature "INSTALL_QSCONFDIR" "${placeholder "out"}/share/caelestia-shell")
  ]
  ++ cmakeVersionFlags;

  postPatch = ''
    substituteInPlace assets/pam.d/fprint \
      --replace-fail pam_fprintd.so /run/current-system/sw/lib/security/pam_fprintd.so
    substituteInPlace assets/pam.d/howdy \
      --replace-fail pam_howdy.so /run/current-system/sw/lib/security/pam_howdy.so
  '';

  postInstall = ''
    makeWrapper ${quickshell}/bin/qs $out/bin/caelestia-shell \
      --prefix PATH : "${lib.makeBinPath runtimeDeps}" \
      --prefix QT_PLUGIN_PATH : "${lib.getLib qt6.qtimageformats}/${qt6.qtbase.qtPluginPrefix}" \
      --set FONTCONFIG_FILE "${fontconfig}" \
      --set CAELESTIA_LIB_DIR ${extras}/lib \
      --set CAELESTIA_XKB_RULES_PATH ${xkeyboard-config}/share/xkeyboard-config-2/rules/base.lst \
      --add-flags "-p $out/share/caelestia-shell"

    mkdir -p $out/lib
    ln -s ${extras}/lib/* $out/lib/
  '';

  passthru = {
    inherit plugin extras m3shapesModule;
    updateScript = ./update.sh;
  };

  meta = {
    description = "Fluid, morphing shell for your Linux desktop";
    homepage = "https://github.com/caelestia-dots/shell";
    license = lib.licenses.gpl3Only;
    mainProgram = "caelestia-shell";
    maintainers = with lib.maintainers; [ rachalaraj ];
    platforms = lib.platforms.linux;
  };
}
