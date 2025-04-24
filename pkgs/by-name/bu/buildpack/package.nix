{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

let
  pname = "pack";
  version = "0.36.1";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "buildpacks";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-pszPntjdEU6zUwA+NawGI3EWjk0fMOFoBr9NPTOSwig=";
  };

  vendorHash = "sha256-4c7tWZ+7L0C0zPjOg/9gJlTXuGacV3uxzxs/TF+7vOo=";

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
