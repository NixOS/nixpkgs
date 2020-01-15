{ stdenv, fetchzip, cmake }:

stdenv.mkDerivation rec {
  pname = "clingo";
  version = "5.3.0";

  src = fetchzip {
    url = "https://github.com/potassco/clingo/archive/v${version}.tar.gz";
    sha256 = "01czx26p8gv81ahrh650x208hjhd8bx1kb688fmk1m4pw4yg5bfv";
  };

  buildInputs = [];
  nativeBuildInputs = [cmake];

  cmakeFlags = [ "-DCLINGO_BUILD_WITH_PYTHON=OFF" ];

  meta = {
    inherit version;
    description = "ASP system to ground and solve logic programs";
    license = stdenv.lib.licenses.mit;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.unix;
    homepage = "https://potassco.org/";
    downloadPage = "https://github.com/potassco/clingo/releases/";
  };
}
