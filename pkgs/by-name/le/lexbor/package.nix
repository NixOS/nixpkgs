{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lexbor";

  # https://github.com/lexbor/lexbor/blob/${finalAttr.src.rev}/source/lexbor/core/base.h#L29-L31
  version = "3.1.0-unstable-2026-09-17";

  src = fetchFromGitHub {
    owner = "lexbor";
    repo = "lexbor";
    rev = "61ef2bc586e1a8a42d257b5b3e6a83689d4b8bce";
    hash = "sha256-XwalZYWJ33t92ld7MlhKefm8BK6zdsZzJp/KIpRQG+Y=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "Open source HTML Renderer library";
    homepage = "https://github.com/lexbor/lexbor";
    changelog = "https://github.com/lexbor/lexbor/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ miniharinn ];
    mainProgram = "lexbor";
    platforms = lib.platforms.all;
  };
})
