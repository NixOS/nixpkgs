{ lib
, stdenv
, fetchFromGitHub
, autoPatchelfHook
, wrapGAppsHook
, hicolor-icon-theme
, gtk3
, gobject-introspection
, libxml2
, fetchpatch
}:
stdenv.mkDerivation rec {
  pname = "deadd-notification-center";
  version = "2021-03-10";

  src = fetchFromGitHub {
    owner = "phuhl";
    repo = "linux_notification_center";
    rev = "640ce0f";
    sha256 = "12ldr8vppylr90849g3mpjphmnr4lp0vsdkj01a5f4bv4ksx35fm";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/phuhl/linux_notification_center/commit/5244e1498574983322be97925e1ff7ebe456d974.patch";
      sha256 = "sha256-hbqbgBmuewOhtx0na2tmFa5W128ZrBvDcyPme/mRzlI=";
    })
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    gobject-introspection
    libxml2
    hicolor-icon-theme
  ];

  buildFlags = [
    # Exclude stack from `make all` to use the prebuilt binary from .out/
    "service"
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "SERVICEDIR_SYSTEMD=${placeholder "out"}/etc/systemd/user"
    "SERVICEDIR_DBUS=${placeholder "out"}/share/dbus-1/services"
    # Override systemd auto-detection.
    "SYSTEMD=1"
  ];

  meta = with lib; {
    description = "A haskell-written notification center for users that like a desktop with style";
    homepage = "https://github.com/phuhl/linux_notification_center";
    license = licenses.bsd3;
    maintainers = [ maintainers.pacman99 ];
    platforms = platforms.linux;
  };
}
