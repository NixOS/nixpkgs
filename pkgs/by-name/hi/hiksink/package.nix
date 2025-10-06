{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "hiksink";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "CornerBit";
    repo = "hiksink";
    rev = version;
    sha256 = "sha256-k/cBCc7DywyBbAzCRCHdrOVmo+QVCsSgDn8hcyTIUI8=";
  };

  cargoHash = "sha256-P5h0jYSSy6i30g93Jor98vOmniJCA4eMyQkI8TLfbN8=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  meta = {
    description = "Tool to convert Hikvision camera events to MQTT";
    homepage = "https://github.com/CornerBit/HikSink";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "hik_sink";
  };
}
