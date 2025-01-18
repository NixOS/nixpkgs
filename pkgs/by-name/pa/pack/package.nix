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
  version = "0.36.2";

  src = fetchFromGitHub {
    owner = "buildpacks";
    repo = "pack";
    rev = "v${version}";
    hash = "sha256-pITQAGt0aMhEfoauPWxAqnr8JxGi4DcqcmgqtooLkd4=";
  };

  vendorHash = "sha256-51Qqq2Jpd1XxUoMN+6j4/VZ4fLCm4I9JwBeTcdSHgQw=";

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
