{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "pack";
  version = "0.40.9";

  src = fetchFromGitHub {
    owner = "buildpacks";
    repo = "pack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RBDkPqlck64ChnXGFa1sa0WmC2T66ZBN6nQbstymSHU=";
  };

  vendorHash = "sha256-iJTEdnWJb1YyZ0mkamlKkCq/dJsMP6s0h+S8Bh3CnVM=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/buildpacks/pack.Version=${finalAttrs.version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd pack \
      --zsh $(PACK_HOME=$PWD $out/bin/pack completion --shell zsh) \
      --bash $(PACK_HOME=$PWD $out/bin/pack completion --shell bash) \
      --fish $(PACK_HOME=$PWD $out/bin/pack completion --shell fish)
  '';

  meta = {
    homepage = "https://buildpacks.io/";
    changelog = "https://github.com/buildpacks/pack/releases/tag/v${finalAttrs.version}";
    description = "CLI for building apps using Cloud Native Buildpacks";
    mainProgram = "pack";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
