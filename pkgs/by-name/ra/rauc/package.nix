{
  composefs,
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
  version = "1.14";

  src = fetchFromGitHub {
    owner = "rauc";
    repo = "rauc";
    rev = "v${version}";
    sha256 = "sha256-tpynDSCQ8E5DE82BvIJ2lEmwFQQpyYkV9UqjKKlArpw=";
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
    composefs
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
    (lib.mesonEnable "composefs" true)
    (lib.mesonOption "systemdunitdir" "${placeholder "out"}/lib/systemd/system")
    (lib.mesonOption "dbusinterfacesdir" "${placeholder "out"}/share/dbus-1/interfaces")
    (lib.mesonOption "dbuspolicydir" "${placeholder "out"}/share/dbus-1/system.d")
    (lib.mesonOption "dbussystemservicedir" "${placeholder "out"}/share/dbus-1/system-services")
    (lib.mesonOption "systemdcatalogdir" "${placeholder "out"}/lib/systemd/catalog")
  ];

  meta = {
    description = "Safe and secure software updates for embedded Linux";
    homepage = "https://rauc.io";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ emantor ];
    platforms = with lib.platforms; linux;
    mainProgram = "rauc";
  };
}
