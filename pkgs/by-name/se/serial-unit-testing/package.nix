{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
}:

rustPlatform.buildRustPackage rec {
  pname = "serial-unit-testing";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "markatk";
    repo = "serial-unit-testing";
    rev = "v${version}";
    hash = "sha256-SLwTwEQdwbus9RFskFjU8m4fS9Pnp8HsgnKkBvTqmSI=";
  };

  cargoHash = "sha256-PoV2v0p0L3CTtC9VMAx2Z/ZsSAIFi2gh2TtOp64S6ZQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    udev
  ];

  # tests require a serial port
  doCheck = false;

  meta = with lib; {
    description = "Automate testing of serial communication with any serial port device";
    homepage = "https://github.com/markatk/serial-unit-testing";
    changelog = "https://github.com/markatk/serial-unit-testing/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ rudolfvesely ];
    mainProgram = "sut";
  };
}
