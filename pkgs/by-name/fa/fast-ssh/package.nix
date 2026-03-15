{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fast-ssh";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "julien-r44";
    repo = "fast-ssh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Wn1kwuY1tRJVe9DJexyQ/h+Z1gNtluj78QpBYjeCbSE=";
  };

  cargoHash = "sha256-qkvonLuS18BBPdBUUnIAbmA+9ZJZFmTRaewrnK9PHFE=";

  meta = {
    description = "TUI tool to use the SSH config for connections";
    homepage = "https://github.com/julien-r44/fast-ssh";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "fast-ssh";
  };
})
