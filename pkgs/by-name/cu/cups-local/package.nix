{
  lib,
  stdenv,
  fetchFromGitHub,
  dbus,
  glibc,
  libcups3,
  pappl2,
  pkg-config,
  systemd,
  nix-update-script,
  enableDbus ? true,
  enableSystemd ? true,
}:
let
  dbusOnDarwinWarning = lib.warnIf (
    enableDbus && stdenv.isDarwin
  ) "DBus is not supported on Darwin. Disabling.";
  systemdWithoutDbusWarning = lib.warnIf (
    enableSystemd && !enableDbus
  ) "Systemd support requires D-Bus. Disabling.";

  useDbus = enableDbus && !stdenv.isDarwin;
  useSystemd = enableSystemd && useDbus;
in
stdenv.mkDerivation {
  pname = "cups-local";
  version = "0-unstable-2024-05-22";

  src = fetchFromGitHub {
    owner = "OpenPrinting";
    repo = "cups-local";
    rev = "90c8047bc7f6025d00403ae07a5d75599c8a0cd5";
    hash = "sha256-mnU7LfRIdAY7veAtQPS+k+bD8rkxqFds4FAN4xtF2lQ=";
  };

  strictDeps = true;
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    glibc
    libcups3
    pappl2
  ] ++ lib.optional useDbus dbus ++ lib.optional useSystemd systemd;

  configureFlags =
    [
      "--localstatedir=/var"
      "--sysconfdir=/etc"
      "--datadir=${placeholder "out"}/share"
      "--localedir=${placeholder "out"}/share/locale"
    ]
    ++ lib.optional (!useDbus) "--disable-dbus"
    ++ lib.optional useDbus "--with-dbusdir=${placeholder "out"}/share/dbus-1"
    ++ lib.optional useSystemd "--with-systemddir=${placeholder "out"}/lib/systemd/system";

  makeFlags = [
    "LDFLAGS=-lm" # TODO: Upstream should be setting this, not us
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "The Common UNIX Printing System (CUPS) library";
    homepage = "https://openprinting.github.io/cups/cups3.html";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
}
