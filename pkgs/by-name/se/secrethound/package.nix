{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "secrethound";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "rafabd1";
    repo = "SecretHound";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ca0AwD1oFBB8F2J4gLMtaDssacczugAkkSYdBTvT4VQ=";
  };

  vendorHash = "sha256-oTyI3/+evDTzyH+BjfSP0A1r2bYVAMxtWRsg0G1d2zQ=";

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
