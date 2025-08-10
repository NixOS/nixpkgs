{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lexbor";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "lexbor";
    repo = "lexbor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wsm+2L2ar+3LGyBXl39Vp9l1l5JONWvO0QbI87TDfWM=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "Lexbor is development of an open source HTML Renderer library";
    homepage = "https://github.com/lexbor/lexbor";
    changelog = "https://github.com/lexbor/lexbor/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "lexbor";
    platforms = lib.platforms.all;
  };
})
