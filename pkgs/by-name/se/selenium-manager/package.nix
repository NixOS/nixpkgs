{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "selenium-manager";
  version = "4.23.0";

  src = fetchFromGitHub {
    owner = "SeleniumHQ";
    repo = "selenium";
    rev = "selenium-${version}";
    hash = "sha256-rZWLivBukHZ5h/I7vJkvis1ITLM903jSUDFPZCPA2L4=";
  };

  sourceRoot = "${src.name}/rust";

  cargoHash = "sha256-HLdKMQj6mhj7ZE+XwUZ0izcOW8P8QpkOV4QB5ZIjj3A=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  # TODO: enable tests
  # The test suite depends on a number of browsers and network requests,
  # check the Gentoo package for inspiration
  doCheck = false;

  meta = with lib; {
    description = "Browser automation framework and ecosystem";
    homepage = "https://github.com/SeleniumHQ/selenium";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    mainProgram = "selenium-manager";
    platforms = platforms.all;
  };
}
