{ mkDerivation, lib, fetchFromGitHub, qmake, poppler, pkgconfig, libunarr
, libGLU, qtdeclarative, qtgraphicaleffects, qtmultimedia, qtquickcontrols
, qtscript
}:

mkDerivation rec {
  pname = "yacreader";
  version = "9.7.1";

  src = fetchFromGitHub {
    owner = "YACReader";
    repo = pname;
    rev = version;
    sha256 = "17kzh69sxpyk4n7c2gkbsvr9y4j14azdy1qxzghsbwp7ij4iw9kv";
  };

  nativeBuildInputs = [ qmake pkgconfig ];
  buildInputs = [ poppler libunarr libGLU qtmultimedia qtscript ];
  propagatedBuildInputs = [ qtquickcontrols qtgraphicaleffects qtdeclarative ];

  enableParallelBuilding = true;

  meta = {
    description = "A comic reader for cross-platform reading and managing your digital comic collection";
    homepage = "http://www.yacreader.com";
    license = lib.licenses.gpl3;
  };
}
