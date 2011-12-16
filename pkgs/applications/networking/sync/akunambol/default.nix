{ stdenv, fetchgit, kdepimlibs, funambol, liblikeback }:

stdenv.mkDerivation rec {
  name = "akunambol-20110304";

  src = fetchgit {
    url = git://anongit.kde.org/akunambol.git;
    rev = "1d832bbbce84f474e3f1e5d2f9fa8a4079b0c8e5";
    sha256 = "1d2x42lbw32qyawri7z0mrbafz36r035w5bxjpq51awyqjwkbb2d";
  };

  buildInputs = [ kdepimlibs funambol liblikeback ];
  KDEDIRS = liblikeback;

  patches = [ ./non-latin.diff ];
}
