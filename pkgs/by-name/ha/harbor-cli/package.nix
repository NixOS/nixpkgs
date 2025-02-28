{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  testers,
  harbor-cli,
  installShellFiles,
}:

buildGoModule rec {
  pname = "harbor-cli";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "goharbor";
    repo = "harbor-cli";
    rev = "v${version}";
    hash = "sha256-Vfr7e5UQ34TkirywuYJPrkxRA6yJp3/ivfCJOnh34MY=";
  };

  vendorHash = "sha256-zQV3YJJ5cu24SVS6LCuZbM5EfGZyNPt8f1N0B3befD0=";

  excludedPackages = [ "dagger" ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.Version=${version}"
  ];

  doCheck = false; # Network required

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    export HOME="$(mktemp -d)"

    installShellCompletion --cmd harbor \
      --bash <($out/bin/harbor completion bash) \
      --fish <($out/bin/harbor completion fish) \
      --zsh <($out/bin/harbor completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = harbor-cli;
    command = "HOME=\"$(mktemp -d)\" harbor version";
  };

  meta = {
    homepage = "https://github.com/goharbor/harbor-cli";
    description = "Command-line tool facilitates seamless interaction with the Harbor container registry";
    changelog = "https://github.com/goharbor/harbor-cli/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "harbor";
  };
}
