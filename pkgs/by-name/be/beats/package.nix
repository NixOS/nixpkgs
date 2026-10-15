{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "beats";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "j0hax";
    repo = "beats";
    rev = "v${finalAttrs.version}";
    hash = "sha256-LkJJiNtG1swdC+SSNVkvqARAQjiQ8Y08OZ7GKzPWu+U=";
  };

  makeFlags = [
    "PREFIX=$(out)"
    "CC=cc"
  ];

  meta = {
    homepage = "https://github.com/j0hax/beats";
    license = lib.licenses.gpl3Only;
    description = "Swatch Internet Time implemented as a C program";
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.j0hax ];
    mainProgram = "beats";
  };
})
