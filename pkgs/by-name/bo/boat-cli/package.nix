{
  lib,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  rustPlatform,
  sqlite,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "boat-cli";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "coko7";
    repo = "boat-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6VrjJYrP/EDK0e303lJT045Ox4Kebn9yr4dbrd8V3F8=";
  };

  cargoHash = "sha256-XbwkN4oHWsaEYkCwf/LtnGJKJFdKdNGjFqUbONBkE68=";

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    sqlite
  ];

  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Basic Opinionated Activity Tracker, a command line interface inspired by bartib.";
    homepage = "https://github.com/coko7/boat-cli";
    changelog = "https://github.com/coko7/boat-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tgi74 ];
    mainProgram = "boat";
  };
})
