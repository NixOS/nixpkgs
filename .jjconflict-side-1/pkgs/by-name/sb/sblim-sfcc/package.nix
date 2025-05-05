{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  curl,
}:

stdenv.mkDerivation {
  pname = "sblim-sfcc";
  version = "2.2.8-unstable-2023-06-26";

  src = fetchFromGitHub {
    owner = "kkaempf";
    repo = "sblim-sfcc";
    rev = "881fccbaf19e26cbef3da1bebe2b42b3a9de1147";
    hash = "sha256-zXQD+IYuMV5vw27FpTpeCfh/mf0wvKzOvc4bplEDJCw=";
  };

  buildInputs = [ curl ];

  nativeBuildInputs = [ autoreconfHook ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Small Footprint CIM Client Library";
    homepage = "https://sourceforge.net/projects/sblim/";
    license = licenses.cpl10;
    maintainers = with maintainers; [ deepfire ];
    platforms = platforms.unix;
  };
}
