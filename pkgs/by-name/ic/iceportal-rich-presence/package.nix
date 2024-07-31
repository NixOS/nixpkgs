{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "iceportal-rich-presence";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "AdriDevelopsThings";
    repo = "iceportal-rich-presence";
    rev = version;
    hash = "sha256-RiSCYiG97RTUq1niA3ouF0GQz5ai3NlW6ZUEHGsHX0w=";
  };

  cargoHash = "sha256-+AIQrGcTR1a1bjgYgyczy54IxeuFLdEKwqyTZmidz1g=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  meta = with lib; {
    description = "Show your current train ride in discord via the ICE portal api";
    homepage = "https://github.com/AdriDevelopsThings/iceportal-rich-presence";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ marie ];
    mainProgram = "iceportal_rich_presence";
  };
}
