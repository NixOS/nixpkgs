{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "selenium-manager";
  version = "4.40.0";

  src = fetchFromGitHub {
    owner = "SeleniumHQ";
    repo = "selenium";
    tag = "selenium-${version}";
    hash = "sha256-Yfm2kpAmmEUP+m48PQf09UvFPeGBxd0ukqTtVah5h+E=";
  };

  sourceRoot = "${src.name}/rust";

  patches = [
    ./disable-telemetry.patch
  ];

  cargoHash = "sha256-D7lki2/xWcNStcHIS8q1fTkW+37Q+m/yetn05DwA2C8=";

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
