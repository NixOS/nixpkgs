{ stdenv, fetchurl, autoconf, automake, pkgconfig
, libX11, libXinerama, libXft, pango, cairo
, libstartup_notification, i3Support ? false, i3
}:

stdenv.mkDerivation rec {
  name = "rofi-${version}";
  version = "0.15.10";

  src = fetchurl {
    url = "https://github.com/DaveDavenport/rofi/archive/${version}.tar.gz";
    sha256 = "0wwdc9dj8qfmqv4pcllq78h38hqmz9s3hqf71fsk71byiid69ln9";
  };

  buildInputs = [ autoconf automake pkgconfig libX11 libXinerama libXft pango
                  cairo libstartup_notification
                ] ++ stdenv.lib.optional i3Support i3;

  preConfigure = ''
    autoreconf -vif
  '';

  meta = {
      description = "Window switcher, run dialog and dmenu replacement";
      homepage = https://davedavenport.github.io/rofi;
      license = stdenv.lib.licenses.mit;
      maintainers = [ stdenv.lib.maintainers.mbakke ];
  };
}
