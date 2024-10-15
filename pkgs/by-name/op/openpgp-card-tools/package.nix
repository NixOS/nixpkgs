{ lib
, stdenv
, rustPlatform
, fetchFromGitea
, pkg-config
, pcsclite
, dbus
, testers
, openpgp-card-tools
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "openpgp-card-tools";
  version = "0.11.4";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "openpgp-card";
    repo = "openpgp-card-tools";
    rev = "v${version}";
    hash = "sha256-XW9UYI588ZQGtBvsElFc2FF2GdYD2kZ2qbr51i3JE3w=";
  };

  cargoHash = "sha256-qpUWy/YTel+xwq2SdilyAyURKxqAYw7hYdQ+fPYtfHk=";

  nativeBuildInputs = [ pkg-config rustPlatform.bindgenHook ];

  buildInputs = [ pcsclite dbus ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
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
