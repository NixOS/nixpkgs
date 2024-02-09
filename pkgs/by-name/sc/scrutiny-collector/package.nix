{ lib, buildGoModule, fetchFromGitHub, makeWrapper, smartmontools }:

buildGoModule rec {
  pname = "scrutiny-collector";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "AnalogJ";
    repo = "scrutiny";
    rev = "v${version}";
    hash = "sha256-UYKi+WTsasUaE6irzMAHr66k7wXyec8FXc8AWjEk0qs=";
  };
  subPackages = "collector/cmd/collector-metrics/collector-metrics.go";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/collector-metrics \
        --set PATH ${lib.makeBinPath [ smartmontools ]}:/usr/sbin
  '';

  vendorHash = "sha256-SiQw6pq0Fyy8Ia39S/Vgp9Mlfog2drtVn43g+GXiQuI=";

  meta = with lib; {
    description = "Hard Drive S.M.A.R.T Monitoring, Historical Trends & Real World Failure Thresholds";
    homepage = "https://github.com/AnalogJ/scrutiny";
    changelog = "https://github.com/AnalogJ/scrutiny/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ maintainers.dudeofawesome ];
  };
}
