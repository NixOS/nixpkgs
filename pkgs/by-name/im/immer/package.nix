{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "immer";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "arximboldi";
    repo = "immer";
    rev = "v${version}";
    hash = "sha256-R0C6hN50eyFSv10L/Q0tRdnUrRvze+eRXPrlAQsddYY=";
  };

  nativeBuildInputs = [ cmake ];
  dontBuild = true;
  dontUseCmakeBuildDir = true;

  meta = with lib; {
    description = "Postmodern immutable and persistent data structures for C++ — value semantics at scale";
    homepage = "https://sinusoid.es/immer";
    changelog = "https://github.com/arximboldi/immer/releases/tag/v${version}";
    license = licenses.boost;
    maintainers = with maintainers; [ sifmelcara ];
    platforms = platforms.all;
  };
}
