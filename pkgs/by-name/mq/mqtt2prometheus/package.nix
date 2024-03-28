{ fetchFromGitHub
, buildGoModule
, lib
, testers
, mqtt2prometheus
, nixosTests
}:
buildGoModule rec {
  pname = "mqtt2prometheus";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "hikhvar";
    repo = "mqtt2prometheus";
    rev = "v${version}";
    hash = "sha256-D5AO6Qsz44ssmRu80PDiRjKSxkOUe4OSm+xtvyGkdUQ=";
  };

  vendorHash = "sha256-5P5J1HwlOFMaGj77k4jU8uJtm0XUIqdPT9abRcvHt2s=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/mqtt2prometheus
  '';

  passthru = {
    tests = {
      version = testers.testVersion { package = mqtt2prometheus; };
      inherit (nixosTests) mqtt2prometheus;
    };
  };

  meta = {
    description = "MQTT to Prometheus gateway";
    homepage = "https://github.com/hikhvar/mqtt2prometheus";
    changelog = "https://github.com/hikhvar/mqtt2prometheus/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "mqtt2prometheus";
    maintainers = with lib.maintainers; [ lesuisse ];
  };
}
