{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "aoc-cli";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "scarvalhojr";
    repo = "aoc-cli";
    tag = finalAttrs.version;
    hash = "sha256-UdeCKhEWr1BjQ6OMLP19OLWPlvvP7FGAO+mi+bQUPQA=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  cargoHash = "sha256-cm8yt7PRjar21EVFIjXYgDkO7+VpHGIB3tJ8hkK+Phw=";

  meta = {
    description = "Advent of code command line tool";
    homepage = "https://github.com/scarvalhojr/aoc-cli/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jordanisaacs ];
    mainProgram = "aoc";
  };
})
