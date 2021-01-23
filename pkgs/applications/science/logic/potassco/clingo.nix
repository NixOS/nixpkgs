{ lib, stdenv, fetchzip, cmake }:

stdenv.mkDerivation rec {
  pname = "clingo";
  version = "5.4.1";

  src = fetchzip {
    url = "https://github.com/potassco/clingo/archive/v${version}.tar.gz";
    sha256 = "1f0q5f71s696ywxcjlfz7z134m1h7i39j9sfdv8hlw2w3g5nppc3";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DCLINGO_BUILD_WITH_PYTHON=OFF" ];

  meta = {
    inherit version;
    description = "ASP system to ground and solve logic programs";
    license = lib.licenses.mit;
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.unix;
    homepage = "https://potassco.org/";
    downloadPage = "https://github.com/potassco/clingo/releases/";
  };
}
