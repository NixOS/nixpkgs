{ stdenv, fetchurl, pkgconfig, libX11, libXft, libXmu }:

stdenv.mkDerivation rec {
  name = "windowmaker-${version}";
  version = "0.95.4";

  src = fetchurl {
    url = "http://windowmaker.org/pub/source/release/"
        + "WindowMaker-${version}.tar.gz";
    sha256 = "0icffqnmkkjjf412m27wljbf9vxb2ry4aiyi2pqmzw3h0pq9gsib";
  };

  buildInputs = [ pkgconfig libX11 libXft libXmu ];

  meta = {
    homepage = "http://windowmaker.org/";
    description = "NeXTSTEP-like window manager";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
