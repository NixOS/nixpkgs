{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "selenium-manager";
  version = "4.32.0";

  src = fetchFromGitHub {
    owner = "SeleniumHQ";
    repo = "selenium";
    tag = "selenium-${version}";
    hash = "sha256-s2vWyxQm5qReB99ja0PQrKmF8QSitMCqs+BkWjqjh8I=";
  };

  sourceRoot = "${src.name}/rust";

  patches = [
    ./disable-telemetry.patch
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-X0qi4uDoZTIFoWg0G8YTBS3j94gcAHnEyVH1wMoR68M=";

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
