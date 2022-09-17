{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "clingo";
  version = "5.6.0";

  src = fetchFromGitHub {
    owner = "potassco";
    repo = "clingo";
    rev = "v${version}";
    sha256 = "sha256-3qyQ7CnpELs6IsDxrW+IbV/TmlfYxP9VIVVjc7sM9fg=";
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
