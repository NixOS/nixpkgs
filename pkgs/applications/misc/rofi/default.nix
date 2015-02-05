{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig
, libX11, libXinerama, libXft, pango
, i3Support ? false, i3
}:

stdenv.mkDerivation rec {
  version = "0.15.1";
  name = "rofi-${version}";

  src = fetchFromGitHub {
    repo = "rofi";
    owner = "DaveDavenport";
    rev = "${version}";
    sha256 = "11fg85xg7mpw9vldmp163c9y398nvbilwqsl06ms0xbbmpyc2hgz";
  };

  buildInputs = [ libX11 libXinerama libXft pango autoreconfHook pkgconfig
                ] ++ stdenv.lib.optional i3Support i3;

  meta = {
      description = "Window switcher, run dialog and dmenu replacement";
      homepage = https://davedavenport.github.io/rofi;
      license = stdenv.lib.licenses.mit;
  };
}
