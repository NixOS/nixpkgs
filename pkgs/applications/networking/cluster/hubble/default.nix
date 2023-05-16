{ stdenv, lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "hubble";
<<<<<<< HEAD
  version = "0.12.0";
=======
  version = "0.11.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "cilium";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-QtslAJC9qPR1jnyK4SLPVv8YTxOUvrzrSA1TzEwajS8=";
=======
    sha256 = "sha256-OqL0L0VyYeg3Vk46LouuqHWpwYTu1vphJSVd6/hWsvA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  vendorHash = null;

  ldflags = [
    "-s" "-w"
    "-X github.com/cilium/hubble/pkg.GitBranch=none"
    "-X github.com/cilium/hubble/pkg.GitHash=none"
    "-X github.com/cilium/hubble/pkg.Version=${version}"
  ];

  # Test fails at Test_getFlowsRequestWithInvalidRawFilters in github.com/cilium/hubble/cmd/observe
  # https://github.com/NixOS/nixpkgs/issues/178976
  # https://github.com/cilium/hubble/pull/656
  # https://github.com/cilium/hubble/pull/655
  doCheck = false;
  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/hubble version | grep ${version} > /dev/null
  '';

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    installShellCompletion --cmd hubble \
      --bash <($out/bin/hubble completion bash) \
      --fish <($out/bin/hubble completion fish) \
      --zsh <($out/bin/hubble completion zsh)
  '';

  meta = with lib; {
<<<<<<< HEAD
=======
    broken = (stdenv.isLinux && stdenv.isAarch64);
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Network, Service & Security Observability for Kubernetes using eBPF";
    license = licenses.asl20;
    homepage = "https://github.com/cilium/hubble/";
    maintainers = with maintainers; [ humancalico bryanasdev000 ];
  };
}
