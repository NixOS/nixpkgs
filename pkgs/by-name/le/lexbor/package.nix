{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lexbor";
  version = "2.6.0-unstable-2025-11-24";

  src = fetchFromGitHub {
    owner = "lexbor";
    repo = "lexbor";
    rev = "7d726f1bed2f489e79751496c584304e6859ee1b";
    hash = "sha256-vLP/YJWu1Z2kiT0sFLcMPjzMJHJe457oyPTIsxafTfc=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "Open source HTML Renderer library";
    homepage = "https://github.com/lexbor/lexbor";
    changelog = "https://github.com/lexbor/lexbor/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "lexbor";
    platforms = lib.platforms.all;
  };
})
