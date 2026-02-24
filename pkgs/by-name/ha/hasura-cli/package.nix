{
  buildGoModule,
  lib,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "hasura";
  version = "2.48.12";

  src = fetchFromGitHub {
    owner = "hasura";
    repo = "graphql-engine";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-e4GwzViJ3KGy++0cJUgNqHN5iU08xzZwSxb+bczQ9Xo=";
  };
  modRoot = "./cli";

  subPackages = [ "cmd/hasura" ];

  vendorHash = "sha256-riPCH7H1arKP2se2H52R69fL+DyKXK1i/ne5apoS/5w=";

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
