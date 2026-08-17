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
  version = "25.3.7";

  src = fetchFromGitHub {
    owner = "dgraph-io";
    repo = "dgraph";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5v2+RooZD6LOfU5UgcfEffMURB6qasrpXtn/KofmVQs=";
  };

  vendorHash = "sha256-9JC2Bcd6ldY4t439nTDnd58mcSOg6DdjYqzN/9EvHYc=";

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
