{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  boost,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cryptominisat";
  version = "5.11.21";

  src = fetchFromGitHub {
    owner = "msoos";
    repo = "cryptominisat";
    rev = finalAttrs.version;
    hash = "sha256-8oH9moMjQEWnQXKmKcqmXuXcYkEyvr4hwC1bC4l26mo=";
  };

  strictDeps = true;
  buildInputs = [ boost ];
  nativeBuildInputs = [
    python3
    cmake
  ];

  # musl does not have sys/unistd.h
  postPatch = ''
    substituteInPlace src/picosat/picosat.c --replace-fail '<sys/unistd.h>' '<unistd.h>'
  '';

  meta = {
    description = "Advanced SAT Solver";
    mainProgram = "cryptominisat5";
    homepage = "https://github.com/msoos/cryptominisat";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mic92 ];
    platforms = lib.platforms.unix;
  };
})
