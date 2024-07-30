{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, dbus
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "girouette";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "gourlaysama";
    repo = "girouette";
    rev = "v${version}";
    hash = "sha256-CROd44lCCXlWF8X/9HyjtTjSlCUFkyke+BjkD4uUqXo=";
  };

  cargoHash = "sha256-AkagcIewHGPBYrITzI1YNPSJIN13bViDU6tbC+IeakY=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "Show the weather in the terminal, in style";
    homepage = "https://github.com/gourlaysama/girouette";
    changelog = "https://github.com/gourlaysama/girouette/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ linuxissuper cafkafk ];
    mainProgram = "girouette";
  };
}
