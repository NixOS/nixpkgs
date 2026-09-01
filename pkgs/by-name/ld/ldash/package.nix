{
  lib,
  rustPlatform,
  fetchFromGitea,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ldash";
  version = "1.3.1";
  __structuredAttrs = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "md-weber";
    repo = "ldash";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ji1sgzDjJ8KVUVaKzhhCFBgIAAzRS2NQ7DTvJxb3PKA=";
  };

  cargoHash = "sha256-9/Dk3FQuSlUWPm4z3VadJl5FYtZ1gFY9mdZwiSXzzvc=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "This is a TUI for hledger to show a nice dashboard";
    homepage = "https://codeberg.org/md-weber/ldash";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "ldash";
  };
})
