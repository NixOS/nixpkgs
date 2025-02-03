{ lib
, stdenv
, rustPlatform
, fetchFromGitea
, pkg-config
, pcsclite
, testers
, openpgp-card-tools
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "openpgp-card-tools";
  version = "0.11.3";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "openpgp-card";
    repo = "openpgp-card-tools";
    rev = "v${version}";
    hash = "sha256-htFhNzBuinj9qiTzcW0eia74jvCT/+9b1aLli594JJQ=";
  };

  cargoHash = "sha256-I2ExtUUM0ZJyhtyzP+IsgiMPMUFVHqPiMHFlvuUMjRc=";

  nativeBuildInputs = [ pkg-config rustPlatform.bindgenHook ];

  buildInputs = [ pcsclite ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.PCSC
    darwin.apple_sdk.frameworks.Security
  ];

  passthru = {
    tests.version = testers.testVersion {
      package = openpgp-card-tools;
    };
  };

  meta = with lib; {
    description = "Tool for inspecting and configuring OpenPGP cards";
    homepage = "https://codeberg.org/openpgp-card/openpgp-card-tools";
    license = with licenses ;[ asl20 /* OR */ mit ];
    maintainers = with maintainers; [ nickcao ];
    mainProgram = "oct";
  };
}
