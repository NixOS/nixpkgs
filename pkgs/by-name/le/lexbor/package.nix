{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lexbor";
  version = "3.0.0-unstable-2026-05-26";

  src = fetchFromGitHub {
    owner = "lexbor";
    repo = "lexbor";
    rev = "393e96313aed03c1d83f441479fc7507b9db9804";
    hash = "sha256-k/5JtruXdIHZZ/7Mg66yydslpxNxXKSmlaCNcRf/bXE='";
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
