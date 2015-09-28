{ stdenv, fetchurl, autoconf, automake, pkgconfig
, libX11, libXinerama, libXft, pango
, i3Support ? false, i3
}:

stdenv.mkDerivation rec {
  name = "rofi-${version}";
  version = "0.15.8";

  src = fetchurl {
    url = "https://github.com/DaveDavenport/rofi/archive/${version}.tar.gz";
    sha256 = "1qhj8xrxfnzy16g577w0zxg1cy885rbqydlbbxgfk0dpjvq70lq6";
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
      maintainers = [ stdenv.lib.maintainers.mbakke ];
  };
}
