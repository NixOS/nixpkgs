{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bugstalker";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "godzie44";
    repo = "BugStalker";
    rev = "v${finalAttrs.version}";
    hash = "sha256-AAeSvy/rvyylPH2jTVBGN95QIc6gumREQYuruhRo2ZI=";
  };

  cargoHash = "sha256-GGi5hnrK5WpvnXHNckpsBch/SJ4lDvH7peSlrCdk218=";

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
