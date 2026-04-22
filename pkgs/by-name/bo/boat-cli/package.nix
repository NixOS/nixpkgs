{
  lib,
  stdenv,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  rustPlatform,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "boat-cli";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "coko7";
    repo = "boat-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N7d/j6Wjz1Kf6CbvmtbNZhaR5OR7VAM8SwsH7jf+tPI=";
  };

  cargoHash = "sha256-PqRy3piwh0aK9YbGjlKcrk7MNBtw453nxdwztCaPaDY=";

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    sqlite
  ];

  __structuredAttrs = true;

  meta = {
    description = "Basic Opinionated Activity Tracker, a command line interface inspired by bartib.";
    homepage = "https://github.com/coko7/boat-cli";
    changelog = "https://github.com/coko7/boat-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tgi74 ];
    mainProgram = "boat";
  };
})
