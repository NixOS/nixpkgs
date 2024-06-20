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
  version = "0.11.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "openpgp-card";
    repo = "openpgp-card-tools";
    rev = "v${version}";
    hash = "sha256-4PRUBzVy1sb15sYsbitBrOfQnsdbGKoR2OA4EjSc8B8=";
  };

  cargoHash = "sha256-Jm1181WQfYZPKnu0f2om/hxkJ8Bm5AA/3IwBgZkpF0I=";

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
    description = "Tool for inspecting and configuring OpenPGP cards";
    homepage = "https://codeberg.org/openpgp-card/openpgp-card-tools";
    license = with licenses ;[ asl20 /* OR */ mit ];
    maintainers = with maintainers; [ nickcao ];
    mainProgram = "oct";
  };
}
