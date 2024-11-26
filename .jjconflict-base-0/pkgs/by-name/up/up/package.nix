{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "up";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "akavel";
    repo = "up";
    rev = "v${version}";
    hash = "sha256-d6FCJ9G9ytHhWQ5lXEtlmzclt3odS9e+Y1ry6EiIDsk=";
  };

  vendorHash = "sha256-PbOMUrKigCUuu5Hv3h0ZYSYezS+64DIZSubnQZ12HOE=";

  meta = with lib; {
    description = "Ultimate Plumber is a tool for writing Linux pipes with instant live preview";
    homepage = "https://github.com/akavel/up";
    maintainers = with maintainers; [ ma27 ];
    license = licenses.asl20;
    mainProgram = "up";
  };
}
