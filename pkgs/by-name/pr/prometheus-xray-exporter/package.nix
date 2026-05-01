{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "xray-exporter";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "compassvpn";
    repo = "xray-exporter";
    rev = "v${version}";
    hash = "sha256-Gk+8ie18FR05b8ynZezPjo9/U6L0vcdOgqcq1ze2v48=";
  };

  vendorHash = "sha256-W+iPYQBs+rAry0yKRoF4Htc8GCfh1iXhbD//KLl8Hlk=";

  meta = with lib; {
    description = "Prometheus exporter for Xray daemon";
    homepage = "https://github.com/compassvpn/xray-exporter";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "xray-exporter";
  };
}
