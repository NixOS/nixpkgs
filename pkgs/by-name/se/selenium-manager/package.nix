{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "selenium-manager";
  version = "4.30.0";

  src = fetchFromGitHub {
    owner = "SeleniumHQ";
    repo = "selenium";
    tag = "selenium-${version}";
    hash = "sha256-YMHNhVa2R1DFoJdJM2SsptZXNd7sGHSO9v6IWdm+Gws=";
  };

  sourceRoot = "${src.name}/rust";

  patches = [
    ./disable-telemetry.patch
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-MjplqPl/DpX7KTMcmTiWeGpAbV3iey+e7DqTUAO+H74=";

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
