{
  lib,
  stdenv,
  acl,
  cmake,
  dbus,
  fcitx5,
  fetchFromGitHub,
  gettext,
  hicolor-icon-theme,
  kdePackages,
  libevdev,
  libinput,
  libnotify,
  libxcb,
  nix-update-script,
  pkg-config,
  qt6,
  udev,
  wayland-scanner,
  xvfb-run,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fcitx5-lotus";
  version = "7.0.2";

  src = fetchFromGitHub {
    owner = "LotusInputMethod";
    repo = "fcitx5-lotus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-52eh3ZRk71Fd1qREd+ytSGUp0a26KhdVdgYIPzyjnQY=";
  };

  passthru = {
    updateScript = nix-update-script { };
  };

  nativeBuildInputs = [
    cmake
    gettext
    hicolor-icon-theme
    kdePackages.extra-cmake-modules
    pkg-config
    qt6.wrapQtAppsHook
    wayland-scanner
  ];

  nativeCheckInputs = [
    dbus
    xvfb-run
  ];

  buildInputs = [
    acl
    dbus
    fcitx5
    kdePackages.extra-cmake-modules
    libevdev
    libinput
    libnotify
    libxcb
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
    udev
  ];

  strictDeps = true;

  __structuredAttrs = true;

  dontWrapQtApps = true;

  doCheck = true;

  preCheck = ''
    export NIXPKGS_QT6_QML_IMPORT_PATH=${qt6.qtdeclarative}/${qt6.qtbase.qtQmlPrefix}
  '';

  cmakeFlags = [
    "-DLOTUS_ALT_EXECUTABLE_PREFIX=/nix/store/"
    "-DLOTUS_SETFACL_EXECUTABLE=${acl}/bin/setfacl"
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doCheck)
  ];

  postFixup = ''
    wrapQtApp $out/bin/fcitx5-lotus-settings \
      --prefix XDG_DATA_DIRS : "${hicolor-icon-theme}/share"
  '';

  meta = {
    description = "Vietnamese input method engine for Fcitx5";
    homepage = "https://github.com/LotusInputMethod/fcitx5-lotus";
    license = with lib.licenses; [
      gpl3Plus
    ];
    maintainers = with lib.maintainers; [
      imcvampire
      justanoobcoder
    ];
    platforms = lib.platforms.linux;
  };
})
