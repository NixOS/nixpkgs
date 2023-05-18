{ mkDerivation, haskellPackages, fetchFromGitHub, lib, writeText }:

let
  # deadd-notification-center.service
  systemd-service = ''
    [Unit]
    Description=Deadd Notification Center
    PartOf=graphical-session.target

    [Service]
    Type=dbus
    BusName=org.freedesktop.Notifications
    ExecStart=$out/bin/deadd-notification-center

    [Install]
    WantedBy=graphical-session.target
  '';
in mkDerivation rec {
  pname = "deadd-notification-center";
  version = "unstable-2022-11-07";

  src = fetchFromGitHub {
    owner = "phuhl";
    repo = "linux_notification_center";
    rev = "f4b8e2b724d86def9e7b0e12ea624f95760352d5";
    hash = "sha256-ClJfWqStULvmj5YRAUDAmn2WOSA2sVtyZsa+qSY51Gk=";
  };

  isLibrary = false;

  isExecutable = true;

  libraryHaskellDepends = with haskellPackages; [
    base bytestring ConfigFile containers dbus directory env-locale
    filepath gi-cairo gi-gdk gi-gdkpixbuf gi-gio gi-glib gi-gobject
    gi-gtk gi-pango haskell-gettext haskell-gi haskell-gi-base
    hdaemonize here lens mtl process regex-tdfa setlocale split stm
    tagsoup text time transformers tuple unix
  ];

  executableHaskellDepends = with haskellPackages; [ base ];

  # Test suite does nothing.
  doCheck = false;

  # Add systemd user unit.
  postInstall = ''
    mkdir -p $out/lib/systemd/user
    echo "${systemd-service}" > $out/lib/systemd/user/deadd-notification-center.service
  '';

  description = "A haskell-written notification center for users that like a desktop with style";
  homepage = "https://github.com/phuhl/linux_notification_center";
  license = lib.licenses.bsd3;
  maintainers = with lib.maintainers; [ melkor333 sna ];
  platforms = lib.platforms.linux;
}
