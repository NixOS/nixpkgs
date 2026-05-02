{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "re-flex";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "Genivia";
    repo = "RE-flex";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Bk5MzcYSzL/mVWuIYNOO4wCq9pYgUSXTDTgIxW3nUfo=";
  };

  outputs = [
    "out"
    "bin"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    homepage = "https://www.genivia.com/doc/reflex/html";
    description = "Regex-centric, fast lexical analyzer generator for C++ with full Unicode support";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ prrlvr ];
    mainProgram = "reflex";
  };
})
