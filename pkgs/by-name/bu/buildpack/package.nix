{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

let
  pname = "pack";
  version = "0.36.2";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "buildpacks";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-pITQAGt0aMhEfoauPWxAqnr8JxGi4DcqcmgqtooLkd4=";
  };

  vendorHash = "sha256-51Qqq2Jpd1XxUoMN+6j4/VZ4fLCm4I9JwBeTcdSHgQw=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/pack" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/buildpacks/pack.Version=${version}"
  ];

  postInstall = ''
    installShellCompletion --cmd pack \
      --zsh $(PACK_HOME=$PWD $out/bin/pack completion --shell zsh) \
      --bash $(PACK_HOME=$PWD $out/bin/pack completion --shell bash) \
      --fish $(PACK_HOME=$PWD $out/bin/pack completion --shell fish)
  '';

  meta = {
    homepage = "https://buildpacks.io/";
    changelog = "https://github.com/buildpacks/pack/releases/tag/v${version}";
    description = "CLI for building apps using Cloud Native Buildpacks";
    mainProgram = "pack";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ momeemt ];
  };
}
