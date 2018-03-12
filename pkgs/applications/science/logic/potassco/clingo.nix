{ stdenv, fetchzip, cmake }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "clingo";
  version = "5.2.2";

  src = fetchzip {
    url = "https://github.com/potassco/clingo/archive/v${version}.tar.gz";
    sha256 = "04rjwpna37gzm8vxr09z3z6ay8y8cxbjd8lga7xvqfpn2l178zjm";
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
