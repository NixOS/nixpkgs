{ stdenv, fetchurl, automoc4, cmake, perl, pkgconfig
, gettext, kdelibs, libXtst, libfakekey, makeWrapper, qca2, qjson
}:

stdenv.mkDerivation rec {
  name = "kdeconnect-${version}";
  version = "0.7.3";

  src = fetchurl {
    url = "http://download.kde.org/unstable/kdeconnect/${version}/src/kdeconnect-kde-${version}.tar.xz";
    sha256 = "1vrr047bq5skxvibv5pb9ch9dxh005zmar017jzbyb9hilxr8kg4";
  };

  buildInputs = [ gettext kdelibs libXtst libfakekey makeWrapper qca2 qjson ];

  nativeBuildInputs = [ automoc4 cmake perl pkgconfig ];

  meta = with stdenv.lib; {
    description = "A tool to connect and sync your devices with KDE";
    longDescription = ''
        The corresponding Android app, "KDE Connect", is available in
        F-Droid and Google play and has the following features:

        - Share files and URLs to KDE from any app
        - Clipboard share: copy from or to your desktop
        - Notifications sync (4.3+): Read your Android notifications from KDE
        - Multimedia remote control: Use your phone as a remote control
        - WiFi connection: no usb wire or bluetooth needed
        - RSA Encryption: your information is safe 
    '';
    license = licenses.gpl2;
    homepage = https://projects.kde.org/projects/playground/base/kdeconnect-kde;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
