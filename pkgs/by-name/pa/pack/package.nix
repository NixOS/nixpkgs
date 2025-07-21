{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  testers,
  pack,
}:

buildGoModule (finalAttrs: {
  pname = "pack";
  version = "0.37.0";

  src = fetchFromGitHub {
    owner = "buildpacks";
    repo = "pack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QCN0UvWa5u9XX5LvY3yD8Xz2s1XzZUg/WXnAfWwZnY0=";
  };

  vendorHash = "sha256-W8FTk2eJYaTE9gCRwrT+mDhda/ZZeCytqQ9vvVZZHSQ=";

  subPackages = [ "cmd/pack" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/buildpacks/pack.Version=${finalAttrs.version}"
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
})
