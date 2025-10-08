{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "selenium-manager";
  version = "4.36.0";

  src = fetchFromGitHub {
    owner = "SeleniumHQ";
    repo = "selenium";
    tag = "selenium-${version}";
    hash = "sha256-ICP6saP1Ks9RA66jTkN8wK+vF28+nPxtlm91QwthaRY=";
  };

  sourceRoot = "${src.name}/rust";

  patches = [
    ./disable-telemetry.patch
  ];

  cargoHash = "sha256-E+4Y2n8RAsKC0Cd9Xqa5anGLpvxCH1k7LbGTlLbheo8=";

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
