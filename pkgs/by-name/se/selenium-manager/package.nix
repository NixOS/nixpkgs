{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "selenium-manager";
  version = "4.41.0";

  src = fetchFromGitHub {
    owner = "SeleniumHQ";
    repo = "selenium";
    tag = "selenium-${version}";
    hash = "sha256-Yq0GQps5G+Ll5RRtyO6gAvEBwPQ79qYHlaQfAv6Uzu8=";
  };

  sourceRoot = "${src.name}/rust";

  patches = [
    ./disable-telemetry.patch
  ];

  cargoHash = "sha256-XWrtWcEYn4zlM9Ksly5vPXLGfizdJ+GlgNGju+hd3D4=";

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
