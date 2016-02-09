{ stdenv, fetchurl, autoreconfHook, pkgconfig
, libX11, libXinerama, pango, cairo
, libstartup_notification, i3Support ? false, i3
}:

stdenv.mkDerivation rec {
  name = "rofi-${version}";
  version = "0.15.12";

  src = fetchurl {
    url = "https://github.com/DaveDavenport/rofi/archive/${version}.tar.gz";
    sha256 = "112fgx2awsw1xf1983bmy3jvs33qwyi8qj7j59jqc4gx07nv1rp5";
  };

  buildInputs = [ autoreconfHook pkgconfig libX11 libXinerama pango
                  cairo libstartup_notification
                ] ++ stdenv.lib.optional i3Support i3;

  meta = {
      description = "Window switcher, run dialog and dmenu replacement";
      homepage = https://davedavenport.github.io/rofi;
      license = stdenv.lib.licenses.mit;
      maintainers = [ stdenv.lib.maintainers.mbakke ];
  };
}
