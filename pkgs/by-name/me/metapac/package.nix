{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "metapac";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "ripytide";
    repo = "metapac";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kJ2PhV2okr7b6a6Wy+hCT/pagGcr30Wo+mGdoGOF+d8=";
  };

  cargoHash = "sha256-Qu++g77TR4W5umCDFJ1dVbMxuNEUux2WfvGl4iUtxB0=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Multi-backend declarative package manager";
    longDescription = ''
      metapac allows you to maintain a consistent set of packages
      across multiple machines. It also makes setting up a new system
      with your preferred packages from your preferred package
      managers much easier.
    '';
    homepage = "https://github.com/ripytide/metapac";
    changelog = "https://github.com/ripytide/metapac/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "metapac";
  };
})
