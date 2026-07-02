{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lexbor";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "lexbor";
    repo = "lexbor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-P5ng/9lkjaWlZmyFzd3MpN39qBqhe8Rlkb/vv3cZ1MI=";
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
