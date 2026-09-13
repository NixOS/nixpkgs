{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "purefetch";
  version = "0.2.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ooonea";
    repo = "purefetch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Pp3WfRb9Nt95pbZfU5enqlERRafHOtk9fpvZwt77TYs=";
  };

  cargoHash = "sha256-kvXQzP9JD6hkcTjrMJnM8v+MzLEzJD47kDrJkYKlsYU=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast, fastfetch-style system information tool written entirely in Rust with zero dependencies";
    homepage = "https://github.com/ooonea/purefetch";
    changelog = "https://github.com/ooonea/purefetch/blob/v${finalAttrs.version}/CHANGELOG.md";
    license =
      with lib.licenses;
      OR [
        mit
        asl20
      ];
    mainProgram = "purefetch";
    maintainers = with lib.maintainers; [ ooonea ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
