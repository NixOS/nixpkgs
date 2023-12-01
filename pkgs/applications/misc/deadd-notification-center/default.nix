{ mkDerivation, haskellPackages, fetchFromGitHub, lib }:

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
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "phuhl";
    repo = "linux_notification_center";
    rev = version;
    hash = "sha256-VU9NaQVS0n8hFRjWMvCMkaF5mZ4hpnluV31+/SAK7tU=";
  };

  isLibrary = false;

  isExecutable = true;

  libraryHaskellDepends = with haskellPackages; [
    aeson base bytestring ConfigFile containers dbus directory env-locale
    filepath gi-cairo gi-gdk gi-gdkpixbuf gi-gio gi-glib gi-gobject
    gi-gtk gi-pango haskell-gettext haskell-gi haskell-gi-base
    hdaemonize here lens mtl process regex-tdfa setlocale split stm
    tagsoup text time transformers tuple unix yaml
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
