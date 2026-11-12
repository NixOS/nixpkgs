{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "hasura";
  version = "2.51.6";

  src = fetchFromGitHub {
    owner = "hasura";
    repo = "graphql-engine";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-fj+60/gZV2VZrXqWIxwF4nVbMqF5EpIVdBAXSFz4K3U=";
  };
  modRoot = "./cli";

  subPackages = [ "cmd/hasura" ];

  vendorHash = "sha256-RQJAOGzpVq1n+3aEDnnkgvq7EAre9JhBSRAIDqn6jUo=";

  doCheck = false;

  ldflags = [
    "-X github.com/hasura/graphql-engine/cli/version.BuildVersion=${finalAttrs.version}"
    "-s"
    "-w"
  ];

  postInstall = ''
    mkdir -p $out/share/{bash-completion/completions,zsh/site-functions}

    export HOME=$PWD
    $out/bin/hasura completion bash > $out/share/bash-completion/completions/hasura
    $out/bin/hasura completion zsh > $out/share/zsh/site-functions/_hasura
  '';

  meta = {
    homepage = "https://www.hasura.io";
    maintainers = [ lib.maintainers.lassulus ];
    license = lib.licenses.asl20;
    description = "Hasura GraphQL Engine CLI";
    mainProgram = "hasura";
  };
})
