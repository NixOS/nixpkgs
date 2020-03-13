{ stdenv, fetchurl, fetchpatch, unzip }:

stdenv.mkDerivation rec {
  name = "jquery-ui-1.11.4";

  src = fetchurl {
    url = "https://jqueryui.com/resources/download/${name}.zip";
    sha256 = "0ciyaj1acg08g8hpzqx6whayq206fvf4whksz2pjgxlv207lqgjh";
  };

  patches = [
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/jquery/jquery-ui/pull/1622.patch";
      sha256 = "0ip563kz6lhwiims5djrxq3mvb7jx9yzkpsqxxhbi9n6qzz7y2az";
      name = "CVE-2016-7103";
    })
  ];

  buildInputs = [ unzip ];

  installPhase =
    ''
      mkdir -p "$out/js"
      cp -rv . "$out/js"
    '';

  meta = {
    homepage = https://jqueryui.com/;
    description = "A library of JavaScript widgets and effects";
    platforms = stdenv.lib.platforms.all;
  };
}
