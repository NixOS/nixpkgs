{
  curl,
  dbus,
  fetchFromGitHub,
  glib,
  json-glib,
  lib,
  nix-update-script,
  openssl,
  pkg-config,
  stdenv,
  meson,
  ninja,
  util-linux,
  libnl,
  systemd,
}:

stdenv.mkDerivation rec {
  pname = "rauc";
  version = "1.13";

  src = fetchFromGitHub {
    owner = "rauc";
    repo = "rauc";
    rev = "v${version}";
    sha256 = "sha256-Vq1dudB8OQveclAIVgiB8jbtp4o2Ga5v61Y6JUjOpbs=";
  };

  passthru = {
    updateScript = nix-update-script { };
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    glib
  ];

  buildInputs = [
    curl
    dbus
    glib
    json-glib
    openssl
    util-linux
    libnl
    systemd
  ];

  mesonFlags = [
    "--buildtype=release"
    (lib.mesonOption "systemdunitdir" "${placeholder "out"}/lib/systemd/system")
    (lib.mesonOption "dbusinterfacesdir" "${placeholder "out"}/share/dbus-1/interfaces")
    (lib.mesonOption "dbuspolicydir" "${placeholder "out"}/share/dbus-1/system.d")
    (lib.mesonOption "dbussystemservicedir" "${placeholder "out"}/share/dbus-1/system-services")
    (lib.mesonOption "systemdcatalogdir" "${placeholder "out"}/lib/systemd/catalog")
  ];

  meta = with lib; {
    description = "Safe and secure software updates for embedded Linux";
    homepage = "https://rauc.io";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ emantor ];
    platforms = with platforms; linux;
    mainProgram = "rauc";
  };
}
