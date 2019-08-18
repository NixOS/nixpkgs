{ stdenv, fetchurl, qmake, poppler, pkgconfig, libunarr, libGLU
, qtdeclarative, qtgraphicaleffects, qtmultimedia, qtquickcontrols, qtscript
}:

stdenv.mkDerivation rec {
  pname = "yacreader";
  version = "9.5.0";

  src = fetchurl {
    url = "https://github.com/YACReader/yacreader/releases/download/${version}/${pname}-${version}-src.tar.xz";
    sha256 = "0cv5y76kjvsqsv4fp99j8np5pm4m76868i1nn40q6hy573dmxwm6";
  };

  nativeBuildInputs = [ qmake pkgconfig ];
  buildInputs = [ poppler libunarr libGLU qtmultimedia qtscript ];
  propagatedBuildInputs = [ qtquickcontrols qtgraphicaleffects qtdeclarative ];

  enableParallelBuilding = true;

  meta = {
    description = "A comic reader for cross-platform reading and managing your digital comic collection";
    homepage = http://www.yacreader.com;
    license = stdenv.lib.licenses.gpl3;
  };
}
