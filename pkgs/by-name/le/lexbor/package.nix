{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lexbor";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "lexbor";
    repo = "lexbor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QmD8p6dySLEeHjCmDSTplXwsy2Z7yHKYlXmPCKwaBfU=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "Open source HTML Renderer library";
    homepage = "https://github.com/lexbor/lexbor";
    changelog = "https://github.com/lexbor/lexbor/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "lexbor";
    platforms = lib.platforms.all;
  };
})
