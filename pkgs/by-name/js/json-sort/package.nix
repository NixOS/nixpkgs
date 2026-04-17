{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "json-sort";
  version = "0.1.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "drupol";
    repo = "json-sort";
    tag = finalAttrs.version;
    hash = "sha256-U88bP1jVk5imwvSSxN16yaelzq1OhztgUA3MK4FbGnY=";
  };

  cargoHash = "sha256-jnuy00eE0/AaZXURjGRt7WPTLcVY4Hl45AuoR04gqRY=";

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
