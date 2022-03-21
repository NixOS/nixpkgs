{ lib, stdenv, fetchurl, wxGTK, subversion, apr, aprutil, python2 }:

stdenv.mkDerivation rec {
  pname = "rapidsvn";
  version = "0.12.1";

  src = fetchurl {
    url = "http://www.rapidsvn.org/download/release/${version}/${pname}-${version}.tar.gz";
    sha256 = "1bmcqjc12k5w0z40k7fkk8iysqv4fw33i80gvcmbakby3d4d4i4p";
  };

  buildInputs = [ wxGTK subversion apr aprutil python2 ];

  configureFlags = [ "--with-svn-include=${subversion.dev}/include"
    "--with-svn-lib=${subversion.out}/lib" ];

  patches = [
    ./fix-build.patch
  ];

  meta = {
    description = "Multi-platform GUI front-end for the Subversion revision system";
    homepage = "http://rapidsvn.tigris.org/";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.viric ];
  };
}
