{ stdenv, lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, nix-update-script, k9s }:

buildGoModule rec {
  pname = "k9s";
  version = "0.31.7";

  src = fetchFromGitHub {
    owner = "derailed";
    repo = "k9s";
    rev = "v${version}";
    hash = "sha256-DRxS2zhDLAC1pfsHiOEU9Xi7DhKcPwzdI3yw5JbbT18=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X github.com/derailed/k9s/cmd.version=${version}"
    "-X github.com/derailed/k9s/cmd.commit=${src.rev}"
    "-X github.com/derailed/k9s/cmd.date=1970-01-01T00:00:00Z"
  ];

  tags = [ "netgo" ];

  proxyVendor = true;

  vendorHash = "sha256-7eeGME3KOebYYEJEFrrA+5F8rdtYT18WnRoouGyEMD8=";

  # TODO investigate why some config tests are failing
  doCheck = !(stdenv.isDarwin && stdenv.isAarch64);
  # Required to workaround test check error:
  preCheck = "export HOME=$(mktemp -d)";
  # For arch != x86
  # {"level":"fatal","error":"could not create any of the following paths: /homeless-shelter/.config, /etc/xdg","time":"2022-06-28T15:52:36Z","message":"Unable to create configuration directory for k9s"}
  passthru = {
    tests.version = testers.testVersion {
      package = k9s;
      command = "HOME=$(mktemp -d) k9s version -s";
      inherit version;
    };
    updateScript = nix-update-script { };
  };

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    installShellCompletion --cmd k9s \
      --bash <($out/bin/k9s completion bash) \
      --fish <($out/bin/k9s completion fish) \
      --zsh <($out/bin/k9s completion zsh)
  '';

  meta = with lib; {
    description = "Kubernetes CLI To Manage Your Clusters In Style";
    homepage = "https://github.com/derailed/k9s";
    changelog = "https://github.com/derailed/k9s/releases/tag/v${version}";
    license = licenses.asl20;
    mainProgram = "k9s";
    maintainers = with maintainers; [ Gonzih markus1189 bryanasdev000 qjoly ];
  };
}
