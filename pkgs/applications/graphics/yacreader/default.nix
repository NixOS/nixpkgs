{ mkDerivation, lib, fetchFromGitHub, qmake, poppler, pkgconfig, libunarr
, libGLU, qtdeclarative, qtgraphicaleffects, qtmultimedia, qtquickcontrols
, qtscript
}:

mkDerivation rec {
  pname = "yacreader";
  version = "9.6.2";

  src = fetchFromGitHub {
    owner = "YACReader";
    repo = pname;
    rev = version;
    sha256 = "1s7kb72skhr364kq8wr2i012jjmaz2vzcz526h0b2bch8921wrnf";
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
