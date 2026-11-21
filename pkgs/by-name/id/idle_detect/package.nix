{
  stdenv,
  fetchFromGitHub,
  coreutils,
  cmake,
  pkg-config,
  ninja,
  wayland-scanner,
  dbus,
  glib,
  libevdev,
  libx11,
  libxscrnsaver,
  wayland,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "idle_detect";
  version = "0.9.2.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jamescowens";
    repo = "idle_detect";
    tag = finalAttrs.version;
    hash = "sha256-gY9bLHsLE/1XGxe4WrF3CwMF2VIAenvfJvJmaqYvJxs=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \''${CMAKE_INSTALL_PREFIX}/\''${CMAKE_INSTALL_BINDIR} \''${CMAKE_INSTALL_BINDIR} \
      --replace-fail /\''${CMAKE_INSTALL_SYSCONFDIR} \''${CMAKE_INSTALL_SYSCONFDIR} \
      --replace-fail /etc/xdg/autostart \''${CMAKE_INSTALL_SYSCONFDIR}/xdg/autostart
    substituteInPlace dc_event_detection.service.in \
      --replace-fail /bin/sleep ${coreutils}/bin/sleep \
      --replace-fail /etc/event_detect.conf $out/etc/event_detect.conf
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    ninja
    wayland-scanner
  ];

  buildInputs = [
    dbus
    glib
    libevdev
    libx11
    libxscrnsaver
    wayland
  ];

  meta = {
    description = "Compact C++ service for idle detection on a Linux workstation";
    homepage = "https://github.com/jamescowens/idle_detect";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tb148 ];
    platforms = lib.platforms.linux;
  };
})
