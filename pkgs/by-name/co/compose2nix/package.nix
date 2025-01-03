{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  compose2nix,
}:

buildGoModule rec {
  pname = "compose2nix";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "aksiksi";
    repo = "compose2nix";
    rev = "v${version}";
    hash = "sha256-2t4pXTzd5TDpAOzNS8MfnE9p8Rm55OPLaEpSPF4/UbE=";
  };

  vendorHash = "sha256-SwJzyOXE23BLoJ+efFuSIhDTMjirEUmBhGGmgrnKhXw=";

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
