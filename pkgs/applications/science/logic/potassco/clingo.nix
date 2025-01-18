{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "clingo";
  version = "5.7.1";

  src = fetchFromGitHub {
    owner = "potassco";
    repo = "clingo";
    rev = "v${version}";
    sha256 = "sha256-S0JAfMwg49aryKABbC/2oLCEkndVpMVcFE6X0vkbtNc=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DCLINGO_BUILD_WITH_PYTHON=OFF" ];

  meta = with lib; {
    description = "ASP system to ground and solve logic programs";
    license = licenses.mit;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.unix;
    homepage = "https://potassco.org/";
    downloadPage = "https://github.com/potassco/clingo/releases/";
  };
}
