{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "metal-cli";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "equinix";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+hpsGFZHuVhh+fKVcap0vhoUmRs3xPgUwW8SD56m6uI=";
  };

  vendorHash = "sha256-X+GfM73LAWk2pT4ZOPT2pg8YaKyT+SNjQ14LgB+C7Wo=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/equinix/metal-cli/cmd.Version=${version}"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd metal \
      --bash <($out/bin/metal completion bash) \
      --fish <($out/bin/metal completion fish) \
      --zsh <($out/bin/metal completion zsh)
  '';

  doCheck = false;

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/metal --version | grep ${version}
  '';

  meta = with lib; {
    description = "Official Equinix Metal CLI";
    homepage = "https://github.com/equinix/metal-cli/";
    changelog = "https://github.com/equinix/metal-cli/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      Br1ght0ne
      nshalman
      teutat3s
    ];
    mainProgram = "metal";
  };
}
