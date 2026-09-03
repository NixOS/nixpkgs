{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lfsx";
  version = "1.14.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "FerrLabs";
    repo = "LFSX";
    tag = "v${finalAttrs.version}";
    hash = "sha256-muRfcKcc45cl7w9wy34xQh52McAzaCiO1liQ8rlSXwk=";
  };

  cargoHash = "sha256-wpGCB4nUJfJG/GahPBBlQrnVxPn2uF7hB852W53aKr4=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/lfsx";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast, lightweight, secure Git LFS server";
    homepage = "https://lfsx.dev";
    changelog = "https://github.com/FerrLabs/LFSX/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ bryanfrd ];
    mainProgram = "lfsx-server";
    platforms = lib.platforms.unix;
  };
})
