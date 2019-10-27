{ stdenv, fetchzip, cmake }:

stdenv.mkDerivation rec {
  pname = "clingo";
  version = "5.4.0";

  src = fetchzip {
    url = "https://github.com/potassco/clingo/archive/v${version}.tar.gz";
    sha256 = "0gfqlgwg3qx042w6hdc9qpmr50n4vci3p0ddk28f3kqacf6q9q7m";
  };

  nativeBuildInputs = [ cmake ];

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
