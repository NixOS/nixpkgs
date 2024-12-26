{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  testers,
  pack,
}:

buildGoModule rec {
  pname = "pack";
  version = "0.36.1";

  src = fetchFromGitHub {
    owner = "buildpacks";
    repo = "pack";
    rev = "v${version}";
    hash = "sha256-pszPntjdEU6zUwA+NawGI3EWjk0fMOFoBr9NPTOSwig=";
  };

  vendorHash = "sha256-4c7tWZ+7L0C0zPjOg/9gJlTXuGacV3uxzxs/TF+7vOo=";

  subPackages = [ "cmd/pack" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/buildpacks/pack.Version=${version}"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = pack; };
  };

  meta = {
    description = "CLI for building apps using Cloud Native Buildpacks";
    homepage = "https://github.com/buildpacks/pack/";
    license = lib.licenses.asl20;
    mainProgram = "pack";
    maintainers = with lib.maintainers; [ drupol ];
  };
}
