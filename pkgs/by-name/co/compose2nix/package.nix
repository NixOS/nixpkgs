{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  compose2nix,
}:

buildGoModule rec {
  pname = "compose2nix";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "aksiksi";
    repo = "compose2nix";
    rev = "v${version}";
    hash = "sha256-rFnnbRVVv/N5021Al3vmjFAui1cTp8NBZDBNQo8CsXM=";
  };

  vendorHash = "sha256-kiUXgbXJg4x89k2SXf/1e1DLB04ETS+Qp2gx8uJA2DU=";

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
