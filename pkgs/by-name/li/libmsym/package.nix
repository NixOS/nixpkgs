{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "libmsym";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "mcodev31";
    repo = "libmsym";
    rev = "v${version}";
    sha256 = "k+OEwrA/saupP/wX6Ii5My0vffiJ0X9xMCTrliMSMik=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Molecular point group symmetry lib";
    homepage = "https://github.com/mcodev31/libmsym";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.sheepforce ];
  };
}
