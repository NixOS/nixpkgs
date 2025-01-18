{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "log4cplus";
  version = "2.1.2";

  src = fetchurl {
    url = "mirror://sourceforge/log4cplus/log4cplus-${version}.tar.bz2";
    hash = "sha256-JFDfu0qzXdLJ5k2MdQxRS/cpO4HY8yr3qxJEF/cK360=";
  };

  nativeBuildInputs = [ pkg-config ];

  enableParallelBuilding = true;

  strictDeps = true;

  meta = with lib; {
    homepage = "http://log4cplus.sourceforge.net/";
    description = "Port the log4j library from Java to C++";
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
