{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lexbor";
<<<<<<< HEAD
  version = "2.6.0-unstable-2025-11-24";
=======
  version = "2.6.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "lexbor";
    repo = "lexbor";
<<<<<<< HEAD
    rev = "7d726f1bed2f489e79751496c584304e6859ee1b";
    hash = "sha256-vLP/YJWu1Z2kiT0sFLcMPjzMJHJe457oyPTIsxafTfc=";
=======
    tag = "v${finalAttrs.version}";
    hash = "sha256-l+pIUjHqt+pOyEUKoPQm0i9soQUkxLzLMQDStIiycAw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "Open source HTML Renderer library";
    homepage = "https://github.com/lexbor/lexbor";
<<<<<<< HEAD
    changelog = "https://github.com/lexbor/lexbor/blob/${finalAttrs.src.rev}/CHANGELOG.md";
=======
    changelog = "https://github.com/lexbor/lexbor/blob/${finalAttrs.src.tag}/CHANGELOG.md";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "lexbor";
    platforms = lib.platforms.all;
  };
})
