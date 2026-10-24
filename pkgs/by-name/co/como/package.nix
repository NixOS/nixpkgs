{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  python3,
  kdePackages,

  libepoxy,
  libinput,
  wayland,
  pixman,
  wlroots,
  freetype,
  fontconfig,
  wrapland,
  xwayland,
  microsoft-gsl,
  libdrm,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "como";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "winft";
    repo = "como";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-cXCGlrxnJgblDZRfUGIbBHQ1H9L1DYlVypCX7mb76TY=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    python3
    kdePackages.extra-cmake-modules
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = with kdePackages; [
    # Core
    kauth
    kcolorscheme
    kconfig
    kcoreaddons
    kcrash
    kglobalaccel
    ki18n
    kidletime
    knotifications
    kpackage
    ksvg
    kwidgetsaddons
    kwindowsystem

    # Config modules
    kcmutils
    knewstuff
    kservice
    kxmlgui

    # Wayland binary
    kdbusaddons

    # Optional
    kdoctools

    kirigami
    kdecoration
    kscreenlocker
    breeze

    qt5compat
    qtbase
    qttools

    libepoxy
    libinput
    wayland
    pixman
    wlroots
    freetype
    fontconfig
    wrapland
    xwayland
    # qaccessibilityclient
    microsoft-gsl
    libdrm
  ];

  preConfigure = ''
    patchShebangs .
  '';

  # It wants <drm_fourcc.h> and not <libdrm/drm_fourcc.h>
  env.NIX_CFLAGS_COMPILE = "-isystem ${lib.getDev libdrm}/include/libdrm";

  meta = {
    description = "Robust and versatile set of libraries to create compositors for the Wayland and X11 windowing systems";
    homepage = "https://github.com/winft/como";
    license = with lib.licenses; [ gpl2Only ];
    maintainers = with lib.maintainers; [ pluiedev ];
    platforms = lib.platforms.linux;
  };
})
