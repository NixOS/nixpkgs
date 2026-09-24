{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  jemalloc,
  nodejs,
}:

buildGoModule (finalAttrs: {
  pname = "dgraph";
  version = "25.4.0";

  src = fetchFromGitHub {
    owner = "dgraph-io";
    repo = "dgraph";
    tag = "v${finalAttrs.version}";
    hash = "sha256-77uhpDyQhAbeQVGbAB2ZX1YATA5qAk8l5Y7PWhoJm9E=";
  };

  vendorHash = "sha256-Kr4qeoLsqK7qV7OMAvaY7fbzsxaP6bm9bdUZlmQYAug=";

  doCheck = false;

  ldflags = [
    "-X github.com/dgraph-io/dgraph/x.dgraphVersion=${finalAttrs.version}-oss"
  ];

  tags = [
    "oss"
  ];

  nativeBuildInputs = [ installShellFiles ];

  # todo those dependencies are required in the makefile, but verify how they are used
  # actually
  buildInputs = [
    jemalloc
    nodejs
  ];

  subPackages = [ "dgraph" ];

  postInstall = ''
    for shell in bash zsh; do
      $out/bin/dgraph completion $shell > dgraph.$shell
      installShellCompletion dgraph.$shell
    done
  '';

  meta = {
    homepage = "https://dgraph.io/";
    description = "Fast, Distributed Graph DB";
    maintainers = with lib.maintainers; [
      sarahec
      sigma
    ];
    # Apache 2.0 because we use only build "oss"
    license = lib.licenses.asl20;
    mainProgram = "dgraph";
  };
})
