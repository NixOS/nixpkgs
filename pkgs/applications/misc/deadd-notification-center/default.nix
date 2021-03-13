{ lib
, stdenv
, fetchFromGitHub
, autoPatchelfHook
, wrapGAppsHook
, hicolor-icon-theme
, gtk3
, gobject-introspection
, libxml2
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

  installPhase = ''
    mkdir -p $out/bin $out/share/dbus-1/services

    cp $src/.out/${pname} $out/bin/
    chmod +x $out/bin/${pname}

    sed "s|##PREFIX##|$out|g" $src/${pname}.service.in > \
      $out/share/dbus-1/services/com.ph-uhl.deadd.notification.service
  '';

  meta = with lib; {
    description = "A haskell-written notification center for users that like a desktop with style";
    homepage = "https://github.com/phuhl/linux_notification_center";
    license = licenses.bsd3;
    maintainers = [ maintainers.pacman99 ];
    platforms = platforms.linux;
  };
}
