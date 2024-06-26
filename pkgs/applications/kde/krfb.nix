{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  kconfig,
  kcoreaddons,
  kcrash,
  kdbusaddons,
  kdnssd,
  knotifications,
  kwallet,
  kwidgetsaddons,
  kwindowsystem,
  kxmlgui,
  kwayland,
  kpipewire,
  libvncserver,
  libXtst,
  libXdamage,
  qtx11extras,
  pipewire,
  plasma-wayland-protocols,
  wayland,
}:

mkDerivation {
  pname = "krfb";
  meta = {
    homepage = "https://apps.kde.org/krfb/";
    description = "Desktop sharing (VNC)";
    license = with lib.licenses; [
      gpl2Plus
      fdl12Plus
    ];
    maintainers = with lib.maintainers; [ jerith666 ];
  };
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    libvncserver
    libXtst
    libXdamage
    kconfig
    kcoreaddons
    kcrash
    kdbusaddons
    knotifications
    kwallet
    kwidgetsaddons
    kwindowsystem
    kxmlgui
    kwayland
    kpipewire
    qtx11extras
    pipewire
    plasma-wayland-protocols
    wayland
  ];
  propagatedBuildInputs = [ kdnssd ];
}
