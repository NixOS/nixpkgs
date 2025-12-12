{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  jemalloc,
  nodejs,
}:

buildGoModule rec {
  pname = "dgraph";
  version = "25.0.0";

  src = fetchFromGitHub {
    owner = "dgraph-io";
    repo = "dgraph";
    rev = "v${version}";
    sha256 = "sha256-8Lh/urzHGIepXQCXawNvJVe8IOzYs4huDOgw2m/oYiM=";
  };

  vendorHash = "sha256-eArYiLfb8rsFGnPFAoRPQzONifNjds3lahIDRwqz/h0=";

  doCheck = false;

  ldflags = [
    "-X github.com/dgraph-io/dgraph/x.dgraphVersion=${version}-oss"
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
}
