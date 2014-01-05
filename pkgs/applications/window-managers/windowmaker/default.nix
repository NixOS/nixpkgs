{ stdenv, fetchurl, pkgconfig, libX11, libXft, libXmu }:

stdenv.mkDerivation rec {
  name = "windowmaker-${version}";
  version = "0.95.5";

  src = fetchurl {
    url = "http://windowmaker.org/pub/source/release/"
        + "WindowMaker-${version}.tar.gz";
    sha256 = "1l3hmx4jzf6vp0zclqx9gsqrlwh4rvqm1g1zr5ha0cp0zmsg89ab";
  };

  buildInputs = [ pkgconfig libX11 libXft libXmu ];

  meta = {
    homepage = "http://windowmaker.org/";
    description = "NeXTSTEP-like window manager";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
