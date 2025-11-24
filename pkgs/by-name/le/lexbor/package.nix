{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lexbor";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "lexbor";
    repo = "lexbor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l+pIUjHqt+pOyEUKoPQm0i9soQUkxLzLMQDStIiycAw=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "Open source HTML Renderer library";
    homepage = "https://github.com/lexbor/lexbor";
    changelog = "https://github.com/lexbor/lexbor/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "lexbor";
    platforms = lib.platforms.all;
  };
})
