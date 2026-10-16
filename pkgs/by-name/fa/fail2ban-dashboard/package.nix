{
  lib,
  buildGo125Module,
  fetchFromGitHub,
  nixosTests,
}:

buildGo125Module rec {
  pname = "fail2ban-dashboard";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "webishdev";
    repo = "fail2ban-dashboard";
    tag = "v${version}";
    hash = "sha256-MQ0gPdMcdPDtXMOULLZ1cU8HuDioGi47wmcZ2/iClug=";
  };

  vendorHash = "sha256-HYCr0tZebhBE7jTB/ec1JZr4dT1WUsCjpdXN97r1Jes=";

  passthru.tests.nixos = nixosTests.fail2ban-dashboard;

  meta = {
    description = "Web based dashboard for fail2ban";
    homepage = "https://github.com/webishdev/fail2ban-dashboard";
    changelog = "https://github.com/webishdev/fail2ban-dashboard/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    platforms = lib.platforms.linux;
    mainProgram = "fail2ban-dashboard";
  };
}
