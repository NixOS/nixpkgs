{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "secrethound";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "rafabd1";
    repo = "SecretHound";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/P1EgmFch8AMCXuLshZ8HON4q0aaKxKaJRscvRLUm/w=";
  };

  vendorHash = "sha256-Gpbz7Cc6CyQDd3BaNfVIVKL36W/u+sM5g7dJ0Ey+6y8=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "CLI tool designed to find secrets in JavaScript files, web pages, and other text sources";
    homepage = "https://github.com/rafabd1/SecretHound";
    changelog = "https://github.com/rafabd1/SecretHound/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.michaelBelsanti ];
    mainProgram = "secrethound";
  };
})
