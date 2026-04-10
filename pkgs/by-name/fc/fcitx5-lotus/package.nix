{
  lib,
  stdenv,
  acl,
  cmake,
  fcitx5,
  fetchFromGitHub,
  gettext,
  hicolor-icon-theme,
  kdePackages,
  libevdev,
  libinput,
  nix-update-script,
  pkg-config,
  python3,
  qt6,
  udev,
}:

let
  pythonEnv = python3.withPackages (
    ps: with ps; [
      dbus-python
      pyqt6
      qtpy
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "fcitx5-lotus";
  version = "5.0.4";

  src = fetchFromGitHub {
    owner = "LotusInputMethod";
    repo = "fcitx5-lotus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-E1A9PviA9V4I8f/3iLsiLA1nb4EM+nh+WG8sXwbudCA=";
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
  ];

  buildInputs = [
    acl
    fcitx5
    kdePackages.extra-cmake-modules
    libevdev
    libinput
    pythonEnv
    qt6.qtbase
    qt6.qtsvg
    udev
  ];

  strictDeps = true;

  __structuredAttrs = true;

  dontWrapQtApps = true;

  cmakeFlags = [
    "-DLOTUS_ALT_EXECUTABLE_PREFIX=/nix/store/"
    "-DLOTUS_SETFACL_EXECUTABLE=${acl}/bin/setfacl"
  ];

  postFixup = ''
    patchShebangs $out/share/fcitx5-lotus/settings-gui
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
