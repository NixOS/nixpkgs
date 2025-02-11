{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "protoscope";
  version = "unstable-2022-11-09";

  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "protoscope";
    rev = "8e7a6aafa2c9958527b1e0747e66e1bfff045819";
    hash = "sha256-+VIy+CD6bKJzwtpHXRr9MqmsPE2MJ1dRdtvSMUkCh5I=";
  };

  vendorHash = "sha256-mK8eGo6oembs4nofvROn4g0+oO5E5/zQrmPKMe3xXik=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Simple, human-editable language for representing and emitting the Protobuf wire format";
    mainProgram = "protoscope";
    homepage = "https://github.com/protocolbuffers/protoscope";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaronjheng ];
  };
}
