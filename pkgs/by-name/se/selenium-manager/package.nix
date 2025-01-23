{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "selenium-manager";
  version = "4.27.0";

  src = fetchFromGitHub {
    owner = "SeleniumHQ";
    repo = "selenium";
    rev = "selenium-${version}";
    hash = "sha256-1i+kPOWTpLYzwhPgUoQXLQ4k+Q1w9KL2VNxvs38SqPc=";
  };

  sourceRoot = "${src.name}/rust";

  useFetchCargoVendor = true;
  cargoHash = "sha256-bdej8JmkiX5lP5IUQ4XisBVtOYIEspPIsK89CXiqUmM=";

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
