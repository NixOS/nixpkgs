{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "apkscope";
  version = "0.9.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "suffixing";
    repo = "apkscope";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mwVCiR9qn3rXmh4z/s199KO2v7uZL+Dr0rs88XmRV4o=";
  };

  cargoHash = "sha256-mHpaRapaGzfXUUpAWdxt/9SimNEAq80vGYo7rcZRndE=";

  # The upstream vendor was generated on a non-Linux platform
  buildNoDefaultFeatures = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Android reverse engineering for humans and AI agents";
    homepage = "https://github.com/suffixing/apkscope";
    changelog = "https://github.com/suffixing/apkscope/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "apkscope";
  };
})
