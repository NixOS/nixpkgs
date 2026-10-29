{
  lib,
  fetchFromGitHub,
  rustPlatform,
  makeWrapper,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "nightlight";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "smudge";
    repo = "nightlight";
    tag = "v${version}";
    hash = "sha256-NOphjrqsnO5693Zw3NkX3c74I3PdJ8W6sxYwOEJ1yCU=";
  };

  cargoHash = "sha256-v5Oo1AxwvJs66l9CtVjO+WfwgsM16zSLT1SSnDi1kSo=";

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
