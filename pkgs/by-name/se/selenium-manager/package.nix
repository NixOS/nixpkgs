{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "selenium-manager";
  version = "4.43.0";

  src = fetchFromGitHub {
    owner = "SeleniumHQ";
    repo = "selenium";
    tag = "selenium-${version}";
    hash = "sha256-PAg4i0W20WUY9rK2UeE1J2gZSnFsOXnrVHiN9IJas04=";
  };

  sourceRoot = "${src.name}/rust";

  patches = [
    ./disable-telemetry.patch
  ];

  cargoHash = "sha256-mEY6PMGlWbSQ3EtqCc9iEv4vwxjSUhW7OTAy6409uzk=";

  # TODO: enable tests
  # The test suite depends on a number of browsers and network requests,
  # check the Gentoo package for inspiration
  doCheck = false;

  meta = {
    description = "Browser automation framework and ecosystem";
    homepage = "https://github.com/SeleniumHQ/selenium";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "selenium-manager";
    platforms = lib.platforms.all;
  };
}
