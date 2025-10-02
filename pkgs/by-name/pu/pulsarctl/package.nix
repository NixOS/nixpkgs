{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  go,
  testers,
  pulsarctl,
}:

buildGoModule rec {
  pname = "pulsarctl";
  version = "4.0.4.3";

  src = fetchFromGitHub {
    owner = "streamnative";
    repo = "pulsarctl";
    rev = "v${version}";
    hash = "sha256-acNd3nF1nHkYlw7tPoD01IjEc97dLvyAZ7yC1UDWN7s=";
  };

  vendorHash = "sha256-AruXsUIKeUMcojf0XF1ZEaZ2LlXDwCp2n82RN5e0Rj8=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags =
    let
      buildVars = {
        ReleaseVersion = version;
        BuildTS = "None";
        GitHash = src.rev;
        GitBranch = "None";
        GoVersion = "go${go.version}";
      };
    in
    (lib.mapAttrsToList (
      k: v: "-X github.com/streamnative/pulsarctl/pkg/cmdutils.${k}=${v}"
    ) buildVars);

  excludedPackages = [
    "./pkg/test"
    "./pkg/test/bookkeeper"
    "./pkg/test/bookkeeper/containers"
    "./pkg/test/pulsar"
    "./pkg/test/pulsar/containers"
    "./site/gen-pulsarctldocs"
    "./site/gen-pulsarctldocs/generators"
  ];

  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd pulsarctl \
      --bash <($out/bin/pulsarctl completion bash) \
      --fish <($out/bin/pulsarctl completion fish) \
      --zsh <($out/bin/pulsarctl completion zsh)
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = pulsarctl;
      command = "pulsarctl --version";
      version = "v${version}";
    };
  };

  meta = with lib; {
    description = "CLI for Apache Pulsar written in Go";
    homepage = "https://github.com/streamnative/pulsarctl";
    license = with licenses; [ asl20 ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ gaelreyrol ];
    mainProgram = "pulsarctl";
  };
}
