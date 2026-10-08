{
  lib,
  fetchFromGitHub,
  rustPlatform,
  makeWrapper,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "nightlight";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "smudge";
    repo = "nightlight";
    tag = "v${version}";
    hash = "sha256-xoYqC48WFeulr1m3EiLouVH007PD9bdE7ERZzbjxdvk=";
  };

  cargoHash = "sha256-WtzCk2kBO2cWUfNN+xZ84Go4m5/a3BmBayOzy3uU5Wk=";

  checkFlags = [
    "--skip=repl"
    "--skip=printer::tests"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/smudge/nightlight";
    description = "CLI tool for configuring Night Shift macOS";
    maintainers = with lib.maintainers; [ aspauldingcode ];
    platforms = lib.platforms.darwin;
    license = lib.licenses.mit;
    mainProgram = "nightlight";
  };
}
