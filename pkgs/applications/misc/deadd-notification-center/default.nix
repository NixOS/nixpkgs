{ lib, stdenv
, fetchurl
, autoPatchelfHook
, gtk3
, gobject-introspection
, libxml2
}:

let
  version = "1.7.2";

  dbusService = fetchurl {
    url = "https://github.com/phuhl/linux_notification_center/raw/${version}/com.ph-uhl.deadd.notification.service.in";
    sha256 = "0jvmi1c98hm8x1x7kw9ws0nbf4y56yy44c3bqm6rjj4lrm89l83s";
  };
in
stdenv.mkDerivation rec {
  inherit version;
  pname = "deadd-notification-center";

  src = fetchurl {
    url = "https://github.com/phuhl/linux_notification_center/releases/download/${version}/${pname}";
    sha256 = "13f15slkjiw2n5dnqj13dprhqm3nf1k11jqaqda379yhgygyp9zm";
  };

  dontUnpack = true;

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    gtk3
    gobject-introspection
    libxml2
  ];

  installPhase = ''
    mkdir -p $out/bin $out/share/dbus-1/services
    cp $src $out/bin/deadd-notification-center
    chmod +x $out/bin/deadd-notification-center

    sed "s|##PREFIX##|$out|g" ${dbusService} > $out/share/dbus-1/services/com.ph-uhl.deadd.notification.service
  '';

  meta = with lib; {
    description = "A haskell-written notification center for users that like a desktop with style";
    homepage = "https://github.com/phuhl/linux_notification_center";
    license = licenses.bsd3;
    maintainers = [ maintainers.pacman99 ];
    platforms = platforms.linux;
  };
}
