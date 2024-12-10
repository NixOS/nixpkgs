{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "mpris-notifier";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "l1na-forever";
    repo = "mpris-notifier";
    rev = "v${version}";
    hash = "sha256-B1nfVsn95oe2FlHFjb9O4tfL/EqsZZ4JGF0mbJcCg2Y=";
  };

  cargoHash = "sha256-8WzG712/soPgooyR35L8aFIRfPC2MvV3vCcPbkTgoF0=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "Dependency-light, highly-customizable, XDG desktop notification generator for MPRIS status changes";
    homepage = "https://github.com/l1na-forever/mpris-notifier";
    license = licenses.mit;
    maintainers = with maintainers; [ leixb ];
    mainProgram = "mpris-notifier";
  };
}
