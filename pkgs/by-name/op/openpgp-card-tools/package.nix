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
  version = "0.11.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "openpgp-card";
    repo = "openpgp-card-tools";
    rev = "v${version}";
    hash = "sha256-GKBli6ybMDqB105POFEocU2X/xvd56V87k6Y6BsNt18=";
  };

  cargoHash = "sha256-mLZErQhgRWDMdDC5tWjG9NCvLaSdF4A3uCdN8+QMWjU=";

  nativeBuildInputs = [ pkg-config rustPlatform.bindgenHook ];

  buildInputs = [ pcsclite ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.PCSC
    darwin.apple_sdk.frameworks.Security
  ];

  passthru = {
    tests.version = testers.testVersion {
      package = openpgp-card-tools;
    };
  };

  meta = with lib; {
    description = "A tool for inspecting and configuring OpenPGP cards";
    homepage = "https://codeberg.org/openpgp-card/openpgp-card-tools";
    license = with licenses ;[ asl20 /* OR */ mit ];
    maintainers = with maintainers; [ nickcao ];
    mainProgram = "oct";
  };
}
