{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  compose2nix,
}:

buildGoModule rec {
  pname = "compose2nix";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "aksiksi";
    repo = "compose2nix";
    rev = "v${version}";
    hash = "sha256-CWO1iNHl0SFwWp9GeTNnUyEJ9eD8HClp3nSF3pxHxP8=";
  };

  vendorHash = "sha256-pJX73toLWacc1Tz7gbqOIN2CZOu4O2/Usv5lUtjxFRA=";

  passthru.tests = {
    version = testers.testVersion {
      package = compose2nix;
      version = "compose2nix v${version}";
    };
  };

  meta = {
    homepage = "https://github.com/aksiksi/compose2nix";
    changelog = "https://github.com/aksiksi/compose2nix/releases/tag/${src.rev}";
    description = "Generate a NixOS config from a Docker Compose project";
    license = lib.licenses.mit;
    mainProgram = "compose2nix";
    maintainers = with lib.maintainers; [ aksiksi ];
  };
}
