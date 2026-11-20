{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "apkscope";
  version = "0.10.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "suffixing";
    repo = "apkscope";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QdxF7V33eJN8KtsvQhF5C4EAs+ZEuKz6uQIPqkZpqQw=";
  };

  cargoHash = "sha256-DwVcYu02yEvOCIi0c9w4k5eI71rU4W7RkU87SVaIr7A=";

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
