<<<<<<< HEAD
{ mkDerivation, haskellPackages, fetchFromGitHub, lib }:
=======
{ mkDerivation, haskellPackages, fetchFromGitHub, lib, writeText }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
  version = "2.1.1";
=======
  version = "unstable-2022-11-07";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "phuhl";
    repo = "linux_notification_center";
<<<<<<< HEAD
    rev = version;
    hash = "sha256-VU9NaQVS0n8hFRjWMvCMkaF5mZ4hpnluV31+/SAK7tU=";
=======
    rev = "f4b8e2b724d86def9e7b0e12ea624f95760352d5";
    hash = "sha256-ClJfWqStULvmj5YRAUDAmn2WOSA2sVtyZsa+qSY51Gk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  isLibrary = false;

  isExecutable = true;

  libraryHaskellDepends = with haskellPackages; [
<<<<<<< HEAD
    aeson base bytestring ConfigFile containers dbus directory env-locale
    filepath gi-cairo gi-gdk gi-gdkpixbuf gi-gio gi-glib gi-gobject
    gi-gtk gi-pango haskell-gettext haskell-gi haskell-gi-base
    hdaemonize here lens mtl process regex-tdfa setlocale split stm
    tagsoup text time transformers tuple unix yaml
=======
    base bytestring ConfigFile containers dbus directory env-locale
    filepath gi-cairo gi-gdk gi-gdkpixbuf gi-gio gi-glib gi-gobject
    gi-gtk gi-pango haskell-gettext haskell-gi haskell-gi-base
    hdaemonize here lens mtl process regex-tdfa setlocale split stm
    tagsoup text time transformers tuple unix
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
