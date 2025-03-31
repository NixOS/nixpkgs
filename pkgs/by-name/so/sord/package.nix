{
  lib,
  stdenv,
  doxygen,
  fetchFromGitHub,
  meson,
  ninja,
  pcre2,
  pkg-config,
  python3,
  serd,
  zix,
}:

stdenv.mkDerivation rec {
  pname = "sord";
  version = "0.16.18";

  src = fetchFromGitHub {
    owner = "drobilla";
    repo = "sord";
    rev = "v${version}";
    hash = "sha256-cFobmmO2RHJdfCgTyGigzsdLpj7YF6U3r71i267Azks=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
    "man"
  ];

  nativeBuildInputs = [
    doxygen
    meson
    ninja
    pkg-config
    python3
  ];
  buildInputs = [ pcre2 ];
  propagatedBuildInputs = [
    serd
    zix
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "http://drobilla.net/software/sord";
    description = "Lightweight C library for storing RDF data in memory";
    license = with licenses; [
      bsd0
      isc
    ];
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
