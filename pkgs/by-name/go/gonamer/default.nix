{ lib, buildGoModule, installShellFiles, fetchFromGitHub }:

buildGoModule rec {
  pname = "gonamer";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "Hacky-The-Sheep";
    repo = "gonamer";
    rev = "v${version}";
    hash = "sha256-tETbOQ3+alWATj+cljddPwRV+WN2Y50W+OW+rG3FW6g=";
  };

  vendorHash = null;

  GOWORK = "off";

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  postInstall = ''
    installShellCompletion --cmd gonamer \
      --bash <($out/bin/gonamer completion bash) \
      --fish <($out/bin/gonamer completion fish) \
      --zsh <($out/bin/gonamer completion zsh)
  '';

  meta = with lib; {
    description = "A Media Renaming Tool";
    homepage = "https://github.com/Hacky-The-Sheep/gonamer";
    changelog = "https://github.com/Hacky-The-Sheep/gonamer/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ Hacky-The-Sheep ];
  };
}
