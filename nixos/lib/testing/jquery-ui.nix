{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "jquery-ui-1.11.4";

  src = fetchurl {
    url = "http://jqueryui.com/resources/download/${name}.zip";
    sha256 = "0ciyaj1acg08g8hpzqx6whayq206fvf4whksz2pjgxlv207lqgjh";
  };

  buildInputs = [ unzip ];

  installPhase =
    ''
      mkdir -p "$out/js"
      cp -rv . "$out/js"
    '';

  meta = {
    homepage = http://jqueryui.com/;
    description = "A library of JavaScript widgets and effects";
    platforms = stdenv.lib.platforms.all;
  };
}
