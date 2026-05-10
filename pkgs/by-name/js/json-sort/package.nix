{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "json-sort";
  version = "1.1.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "drupol";
    repo = "json-sort";
    tag = finalAttrs.version;
    hash = "sha256-yojMXJiP87l5B7D74V6z9FNvSYebtn71GnB0d+Q7/UI=";
  };

  cargoHash = "sha256-LpZIVWWb8HI1HM3m8Vhfk27bWFpU37GYssmsfEJQAVg=";

  dontUseCargoParallelTests = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line tool to sort JSON object keys in-place, preserving formatting and comments";
    homepage = "https://github.com/drupol/json-sort";
    license = lib.licenses.eupl12;
    mainProgram = "json-sort";
    maintainers = with lib.maintainers; [ drupol ];
    platforms = lib.platforms.all;
  };
})
