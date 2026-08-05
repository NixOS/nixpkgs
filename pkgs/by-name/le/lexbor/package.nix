{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lexbor";
  version = "3.0.0-unstable-2026-07-15";

  src = fetchFromGitHub {
    owner = "lexbor";
    repo = "lexbor";
    rev = "de1d07a7765aad37090cc36f7fac3bb59e21467d";
    hash = "sha256-e8NcTvLCbyCLeGdmmZBM4fmTirWYrQ/46nNqAjAnDzM=";
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
