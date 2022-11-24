{ lib, stdenv, fetchFromGitHub, sqlite, zlib, perl, testers }:

stdenv.mkDerivation (finalAttrs: {
  pname = "tippecanoe";
  version = "2.13.0";

  src = fetchFromGitHub {
    owner = "felt";
    repo = "tippecanoe";
    rev = finalAttrs.version;
    hash = "sha256-YgmePs0GxygR0hvcnRngzW77QZTOygSYvRaYk6oCVls=";
  };

  buildInputs = [ sqlite zlib ];
  checkInputs = [ perl ];

  makeFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;
  doCheck = true;

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = "v${finalAttrs.version}";
  };

  meta = with lib; {
    description = "Build vector tilesets from large collections of GeoJSON features";
    homepage = "https://github.com/felt/tippecanoe";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
})
