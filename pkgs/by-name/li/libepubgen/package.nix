{ lib
, stdenv
, fetchgit
, autoreconfHook
, pkg-config
, boost
, cppunit
, librevenge
, libxml2
}:

stdenv.mkDerivation rec {
  pname = "libepubgen";
  version = "0.1.1";

  src = fetchgit {
    url = "https://git.code.sf.net/p/libepubgen/code";
    rev = "libepubgen-${version}";
    hash = "sha256-wPpU8Sfhx9GIgDmT/otT5yV4iQKm9QPZqgSBTfFcbbg=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    boost
    cppunit
    librevenge
    libxml2
  ];

  meta = with lib; {
    description = "An EPUB generator for librevenge";
    homepage = "https://sourceforge.net/projects/libepubgen/";
    license = licenses.mpl20;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
