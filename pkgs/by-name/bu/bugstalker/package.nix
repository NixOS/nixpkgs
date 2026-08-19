{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bugstalker";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "godzie44";
    repo = "BugStalker";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9l6IVQBjZkpSS28ai/d27JUPBWj2Q17RVhsFrrI45TM=";
  };

  cargoHash = "sha256-+VvKWY9CqUUkDKzG2nLG9ibkE6xwP3StTzlovBZH8O8=";

  # Tests require rustup.
  doCheck = false;

  nativeInstallCheckHook = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Rust debugger for Linux x86-64";
    homepage = "https://github.com/godzie44/BugStalker";
    changelog = "https://github.com/godzie44/BugStalker/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jacg ];
    mainProgram = "bs";
    platforms = [ "x86_64-linux" ];
  };
})
