{ lib
, buildGoModule
, fetchFromGitea
, installShellFiles
}:

buildGoModule rec {
  pname = "ipam";
  version = "0.3.0-1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "lauralani";
    repo = "ipam";
    rev = "v${version}";
    hash = "sha256-6gOkBjXgaMMWFRXFTSBY9YaNPdMRyLl8wy7BT/5vHio=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  vendorHash = "sha256-l8eeeYv41yUPQ1dyJY4Jo3uvULrc1B/buGlMxYSdhCA=";

  ldflags = [ "-s" "-w" ];

  postInstall = ''
    installShellCompletion --cmd ipam \
      --bash <($out/bin/ipam completion bash) \
      --fish <($out/bin/ipam completion fish) \
      --zsh <($out/bin/ipam completion zsh)
  '';

  meta = with lib; {
    description = "Cli based IPAM written in Go with PowerDNS support";
    homepage = "https://ipam.lauka.net/";
    changelog = "https://codeberg.org/lauralani/ipam/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    mainProgram = "ipam";
  };
}
