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
  version = "0.34.2";

  src = fetchFromGitHub {
    owner = "buildpacks";
    repo = "pack";
    rev = "v${version}";
    hash = "sha256-1s/0eBRnir2MyrDALcOi5drCIJVkrPBB4RXKX08mxKs=";
  };

  vendorHash = "sha256-jhgTHhiQUDf9738Zusk1SxEae9G6MQapBRq7DBN5Tuc=";

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
