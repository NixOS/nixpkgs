{ lib, buildGoModule, fetchFromGitHub, fetchpatch, installShellFiles }:

buildGoModule rec {
  pname = "cilium-cli";
  version = "0.12.7";

  src = fetchFromGitHub {
    owner = "cilium";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-libZapDj6Y/tGJEXAX3iZH2+pS64dg7IUsgTxT0Z6JA=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2023-28114.patch";
      url = "https://github.com/cilium/cilium-cli/commit/fb1427025764e1eebc4a7710d902c4f22cae2610.patch";
      hash = "sha256-WHWtv/GP4AhaZBx0WheTCBaZNdnzr8KNqwfKK2BtheY=";
    })
  ];

  vendorSha256 = null;

  subPackages = [ "cmd/cilium" ];

  ldflags = [
    "-s" "-w"
    "-X github.com/cilium/cilium-cli/internal/cli/cmd.Version=${version}"
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
    maintainers = with maintainers; [ humancalico bryanasdev000 ];
    mainProgram = "cilium";
  };
}
