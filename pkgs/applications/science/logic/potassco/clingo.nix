{ lib, stdenv, fetchzip, cmake }:

stdenv.mkDerivation rec {
  pname = "clingo";
  version = "5.5.1";

  src = fetchzip {
    url = "https://github.com/potassco/clingo/archive/v${version}.tar.gz";
    sha256 = "sha256-KBCwGNkz5HqbgXbDxPVcqxMXC8B2+wRI8eZVVXMVpLI=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DCLINGO_BUILD_WITH_PYTHON=OFF" ];

  meta = {
    description = "ASP system to ground and solve logic programs";
    license = lib.licenses.mit;
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.unix;
    homepage = "https://potassco.org/";
    downloadPage = "https://github.com/potassco/clingo/releases/";
  };
}
