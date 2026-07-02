{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  compose2nix,
}:

buildGoModule (finalAttrs: {
  pname = "compose2nix";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "aksiksi";
    repo = "compose2nix";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0QCYgzxg0upnrVGDXbX9GgSHyzeMP3yqNor2t8DVwiU=";
  };

  vendorHash = "sha256-8boWHIGvenGugKq+8ysPCsUib7QQ0ov+jbKFDKpls3g=";

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
