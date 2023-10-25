{ lib, buildGoModule, installShellFiles, fetchFromGitHub }:

buildGoModule rec {
  pname = "pop";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "pop";
    rev = "v${version}";
    sha256 = "VzSPQZfapB44hzGumy8JKe+v+n6af9fRSlAq1F7olCo=";
  };

  vendorSha256 = "VowqYygRKxpDJPfesJXBp00sBiHb57UMR/ZV//v7+90=";

  GOWORK = "off";

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  postInstall = ''
    $out/bin/pop man > pop.1
    installManPage pop.1
    installShellCompletion --cmd pop \
      --bash <($out/bin/pop completion bash) \
      --fish <($out/bin/pop completion fish) \
      --zsh <($out/bin/pop completion zsh)
  '';

  meta = with lib; {
    description = "Send emails from your terminal";
    homepage = "https://github.com/charmbracelet/pop";
    changelog = "https://github.com/charmbracelet/pop/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ caarlos0 maaslalani ];
  };
}
