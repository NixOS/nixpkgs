{
  lib,
  rustPlatform,
  fetchFromCodeberg,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "om";
  version = "0.1.6";

  src = fetchFromCodeberg {
    owner = "undltd";
    repo = "om";
    tag = finalAttrs.version;
    hash = "sha256-hlGwpvEG0W6BwtdYkkz9I3BKO875B2+z0JYlVEw+OAc=";
  };

  cargoHash = "sha256-pO139mVjFAi0NgiUqpJM+hG99uxGFBD6rU+X8kflrh4=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  __structuredAttrs = true;

  meta = {
    description = "Command line tool to conveniently mount, unmount, (un)lock and safely power off storage devices on Linux with as few keystrokes as possible";
    homepage = "https://codeberg.org/undltd/om";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ phijor ];
    mainProgram = "om";
    platforms = lib.platforms.linux;
  };
})
