{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "selenium-manager";
  version = "4.18.1";

  src = fetchFromGitHub {
    owner = "SeleniumHQ";
    repo = "selenium";
    rev = "selenium-${version}";
    hash = "sha256-1C9Epsk9rFlShxHGGzbWl6smrMzPn2h3yCWlzUIMpY8=";
  };

  sourceRoot = "${src.name}/rust";

  cargoHash = "sha256-BystESOFIitw3ER2K1TPOf5luOBvKXFuqc/unL93yRY=";

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
