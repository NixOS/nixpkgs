{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "lxp-bridge";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "celsworth";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7h2SGHAOVWre+xMQIz7fxGqXMO22xH2zIQWWVVMx4z4=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "rinfluxdb-0.1.0" = "sha256-KbuLmrWQmI/kqAmHaLDWDN/bv6WZ/gumAVSw4rnEKaM=";
    };
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  meta = with lib; {
    description = "A bridge to MQTT/InfluxDB/Postgres for communications with LuxPower inverters";
    homepage = "https://github.com/${src.owner}/${src.repo}";
    changelog = "${meta.homepage}/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "lxp-bridge";
    maintainers = with maintainers; [ presto8 ];
  };
}
