{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lexbor";

  # https://github.com/lexbor/lexbor/blob/${finalAttr.src.rev}/source/lexbor/core/base.h#L29-L31
  version = "3.1.0-unstable-2026-09-28";

  src = fetchFromGitHub {
    owner = "lexbor";
    repo = "lexbor";
    rev = "f4cbbcd91359a0ec9499e3ce7e263de629482d61";
    hash = "sha256-Qj8/JWLc4Pjgu1EvnJjxlSygFWmV+7ts5jTmUg14imk=";
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
