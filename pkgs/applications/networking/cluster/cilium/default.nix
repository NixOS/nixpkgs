{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "cilium-cli";
<<<<<<< HEAD
  version = "0.15.7";
=======
  version = "0.14.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "cilium";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-kQpQszKyesM9qFlpgwYElrC9B4YBig62Pf9FoZJ2epM=";
=======
    sha256 = "sha256-y7R9+YxkPWVEjcN8Czfp8UC47AAAt554XLo/nStoGLY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = null;

  subPackages = [ "cmd/cilium" ];

  ldflags = [
    "-s" "-w"
<<<<<<< HEAD
    "-X github.com/cilium/cilium-cli/cli.Version=${version}"
=======
    "-X github.com/cilium/cilium-cli/internal/cli/cmd.Version=${version}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  # Required to workaround install check error:
  # 2022/06/25 10:36:22 Unable to start gops: mkdir /homeless-shelter: permission denied
  HOME = "$TMPDIR";

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/cilium version | grep ${version} > /dev/null
  '';

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    installShellCompletion --cmd cilium \
      --bash <($out/bin/cilium completion bash) \
      --fish <($out/bin/cilium completion fish) \
      --zsh <($out/bin/cilium completion zsh)
  '';

  meta = with lib; {
    description = "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium";
    license = licenses.asl20;
    homepage = "https://www.cilium.io/";
<<<<<<< HEAD
    maintainers = with maintainers; [ humancalico bryanasdev000 qjoly ];
=======
    maintainers = with maintainers; [ humancalico bryanasdev000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    mainProgram = "cilium";
  };
}
