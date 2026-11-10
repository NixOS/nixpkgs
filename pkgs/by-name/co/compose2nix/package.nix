{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  compose2nix,
}:

buildGoModule (finalAttrs: {
  pname = "compose2nix";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "aksiksi";
    repo = "compose2nix";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ynoKp8VeDeIFUGc3j8sP6gEuoY7dt+NtdyJh53T+mjA=";
  };

  vendorHash = "sha256-kSQflAh9QuosJUvw0JhG8hjF/Q3zt3XhlPYQswEs7t4=";

  passthru.tests = {
    version = testers.testVersion {
      package = compose2nix;
      version = "compose2nix v${finalAttrs.version}";
    };
  };

  meta = {
    homepage = "https://github.com/aksiksi/compose2nix";
    changelog = "https://github.com/aksiksi/compose2nix/releases/tag/${finalAttrs.src.rev}";
    description = "Generate a NixOS config from a Docker Compose project";
    license = lib.licenses.mit;
    mainProgram = "compose2nix";
    maintainers = with lib.maintainers; [ aksiksi ];
  };
})
