{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "fast-cpp-csv-parser";
  version = "2021-01-03";

  src = fetchFromGitHub {
    owner = "ben-strasser";
    repo = "fast-cpp-csv-parser";
    rev = "75600d0b77448e6c410893830df0aec1dbacf8e3";
    hash = "sha256-wnFs9bh8BO04czyx3QpDRtCq+N8jyCJDxnCirB+nahI=";
  };

  installPhase = ''
    mkdir -p $out/lib/pkgconfig $out/include
    cp -r *.h $out/include/
    substituteAll ${./fast-cpp-csv-parser.pc.in} $out/lib/pkgconfig/fast-cpp-csv-parser.pc
  '';

  meta = {
    description = "Small, easy-to-use and fast header-only library for reading comma separated value (CSV) files";
    homepage = "https://github.com/ben-strasser/fast-cpp-csv-parser";
    license = lib.licenses.bsd3;
  };
}
