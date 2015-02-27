{ stdenv, fetchFromGitHub, autoconf, automake, pkgconfig
, libX11, libXinerama, libXft, pango
, i3Support ? false, i3
}:

stdenv.mkDerivation rec {
  name = "rofi-${version}";
  version = "0.15.2";

  src = fetchFromGitHub {
    repo = "rofi";
    owner = "DaveDavenport";
    rev = "${version}";
    sha256 = "0b8k5g2fpqrz1yac09kmfk4caxcc107qq4yhncnl159xdxw66vz8";
  };

  buildInputs = [ autoconf automake pkgconfig libX11 libXinerama libXft pango
                ] ++ stdenv.lib.optional i3Support i3;

  preConfigure = ''
    autoreconf -vif
  '';

  meta = {
      description = "Window switcher, run dialog and dmenu replacement";
      homepage = https://davedavenport.github.io/rofi;
      license = stdenv.lib.licenses.mit;
  };
}
