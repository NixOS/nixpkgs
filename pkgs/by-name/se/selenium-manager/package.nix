{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "selenium-manager";
  version = "4.21.0";

  src = fetchFromGitHub {
    owner = "SeleniumHQ";
    repo = "selenium";
    rev = "selenium-${version}";
    hash = "sha256-VLz+wvxaqIqDe92ffgld1AYa10rKksGvcHVqcWog+HI=";
  };

  sourceRoot = "${src.name}/rust";

  cargoHash = "sha256-OG9fdox0ZqeI2Cssxcd9b8vOxmC7eT29IUZaEMt8wV0=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  # TODO: enable tests
  # The test suite depends on a number of browsers and network requests,
  # check the Gentoo package for inspiration
  doCheck = false;

  meta = with lib; {
    description = "A browser automation framework and ecosystem";
    homepage = "https://github.com/SeleniumHQ/selenium";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    mainProgram = "selenium-manager";
    platforms = platforms.all;
  };
}
