{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "selenium-manager";
  version = "4.28.0";

  src = fetchFromGitHub {
    owner = "SeleniumHQ";
    repo = "selenium";
    tag = "selenium-${version}";
    hash = "sha256-b5xwuZ4lcwLbGhJuEmHYrFXoaTW/M0ABdK3dvbpj8oM=";
  };

  sourceRoot = "${src.name}/rust";

  useFetchCargoVendor = true;
  cargoHash = "sha256-hXtF3qFzzM2TqpEP9JWdi7uU5TgFHF9lZO5bmZcEuDk=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
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
    maintainers = [ ];
    mainProgram = "selenium-manager";
    platforms = platforms.all;
  };
}
