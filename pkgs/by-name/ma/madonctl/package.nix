{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  madonctl,
}:

buildGoModule rec {
  pname = "madonctl";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "McKael";
    repo = "madonctl";
    rev = "v${version}";
    hash = "sha256-R/es9QVTBpLiCojB/THWDkgQcxexyX/iH9fF3Q2tq54=";
  };

  vendorHash = null;

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd madonctl \
      --bash <($out/bin/madonctl completion bash) \
      --zsh <($out/bin/madonctl completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = madonctl;
    command = "madonctl version";
  };

  meta = with lib; {
    description = "CLI for the Mastodon social network API";
    homepage = "https://github.com/McKael/madonctl";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "madonctl";
  };
}
