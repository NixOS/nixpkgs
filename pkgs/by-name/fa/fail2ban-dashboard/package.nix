{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "fail2ban-dashboard";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "webishdev";
    repo = "fail2ban-dashboard";
    tag = "v${version}";
    hash = "sha256-z1zsymP9HAd9q7wCdJJ0622kcGhI9FtuxovbWo7sKf8=";
  };

  vendorHash = "sha256-puQ8BPuKzUXBDwr2qBvV2KclfxpSrtCTQSCfGaaxKqc=";

  meta = {
    description = "web based dashboard for fail2ban";
    homepage = "https://github.com/webishdev/fail2ban-dashboard";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    mainProgram = "fail2ban-dashboard";
  };
}
