{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "duat";
  version = "0.7.8";

  src = fetchFromGitHub {
    owner = "AhoyISki";
    repo = "duat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HPxpLhis66zjWuftRj59emxxv4TzFVeJJsfFPLGOPtg=";
  };

  cargoHash = "sha256-6aPPzwjhaF6cFyyIE8DylRVG2blJVO0NKpd5Xs8tQbU=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern and customizable text editor, built and configured in Rust";
    homepage = "https://github.com/AhoyISki/duat";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "duat";
  };
})
