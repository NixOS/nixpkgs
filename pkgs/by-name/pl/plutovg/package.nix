{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "plutovg";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "sammycage";
    repo = "plutovg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xNWwACKGU5UIJviVZ3wU4GMuRxKn/rR8jBsZQpZiFZ8=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    homepage = "https://github.com/sammycage/plutovg/";
    changelog = "https://github.com/sammycage/plutovg/releases/tag/v${finalAttrs.version}";
    description = "Tiny 2D vector graphics library in C";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.eymeric ];
  };
})
