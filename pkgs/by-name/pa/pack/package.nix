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
  version = "0.35.1";

  src = fetchFromGitHub {
    owner = "buildpacks";
    repo = "pack";
    rev = "v${version}";
    hash = "sha256-iQkYtnobhAt73JMRrejk0DkOH1ZW2bqfZx05ZrDG5bA=";
  };

  vendorHash = "sha256-gp6Hd0MZxtUX0yYshFIGwrm6yY2pdSOtUs6xmzXBqc4=";

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
