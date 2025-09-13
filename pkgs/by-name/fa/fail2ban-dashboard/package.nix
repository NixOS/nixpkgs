{
  lib,
  buildGo125Module,
  fetchFromGitHub,
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

  meta = {
    description = "web based dashboard for fail2ban";
    homepage = "https://github.com/webishdev/fail2ban-dashboard";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    mainProgram = "fail2ban-dashboard";
  };
}
