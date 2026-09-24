{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "exoscale-cli";
  version = "1.93.0";

  src = fetchFromGitHub {
    owner = "exoscale";
    repo = "cli";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-8GEho1mlxqggVFwUtvpMGyJKk/E+eFN2FnCQJwK51L0=";
  };

  vendorHash = null;

  nativeBuildInputs = [ installShellFiles ];

  excludedPackages = [ "internal/integ" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=${finalAttrs.src.rev}"
  ];

  # we need to rename the resulting binary but can't use buildFlags with -o here
  # because these are passed to "go install" which does not recognize -o
  postBuild = ''
    mv $GOPATH/bin/cli $GOPATH/bin/exo

    mkdir -p manpage
    $GOPATH/bin/docs --man-page
    rm $GOPATH/bin/docs

    $GOPATH/bin/completion bash
    $GOPATH/bin/completion zsh
    rm $GOPATH/bin/completion
  '';

  postInstall = ''
    installManPage manpage/*
    installShellCompletion --cmd exo --bash bash_completion --zsh zsh_completion
  '';

  meta = {
    description = "Command-line tool for everything at Exoscale: compute, storage, dns";
    homepage = "https://github.com/exoscale/cli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ viraptor ];
    mainProgram = "exo";
  };
})
