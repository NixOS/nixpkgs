{ mkDerivation, lib, fetchFromGitHub, qmake, poppler, pkgconfig, libunarr
, libGLU, qtdeclarative, qtgraphicaleffects, qtmultimedia, qtquickcontrols
, qtscript
}:

mkDerivation rec {
  pname = "yacreader";
  version = "9.7.0";

  src = fetchFromGitHub {
    owner = "YACReader";
    repo = pname;
    rev = version;
    sha256 = "0cwds1rvyyh0qh9il46g1lsw3pvx96j90rjvl6rv5byndpgap6vh";
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
