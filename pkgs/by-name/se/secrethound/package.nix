{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "secrethound";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "rafabd1";
    repo = "SecretHound";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TyN7byX4rkRXrKzcx/u/LYNqVRBue2YNJRnkF+f34jQ=";
  };

  vendorHash = "sha256-oTyI3/+evDTzyH+BjfSP0A1r2bYVAMxtWRsg0G1d2zQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "A powerful CLI tool designed to find secrets in JavaScript files, web pages, and other text sources.";
    homepage = "https://github.com/rafabd1/SecretHound";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.michaelBelsanti ];
    mainProgram = "secrethound";
  };
})
