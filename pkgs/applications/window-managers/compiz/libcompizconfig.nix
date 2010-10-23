{ stdenv, fetchurl,intltool, pkgconfig, xlibs, libxml2, libxslt, compiz }:

stdenv.mkDerivation rec {
  name = "libcompizconfig-0.8.4";

  src = fetchurl {
    url = "http://releases.compiz.org/components/libcompizconfig/${name}.tar.bz2";
    sha256 = "0adhl2nc2zrswl5n4a8ipymffq6yjwnxgpkv6rsk7sqvby9kwca1";
  };

  patches =
    [ # See ./core.nix.
      ./plugindir-libcompizconfig.patch
    ];

  buildInputs = [ pkgconfig intltool xlibs.libX11 compiz libxml2 libxslt ];

  meta = {
    homepage = http://www.compiz.org/;
    description = "Compiz configuration library";
  };
}
