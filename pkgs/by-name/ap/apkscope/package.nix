{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "apkscope";
  version = "0.12.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "suffixing";
    repo = "apkscope";
    tag = "v${finalAttrs.version}";
    hash = "sha256-alTpsr3RKXuorum9sulfWzHdE1/rANLQSJX+1BvRzSY=";
  };

  cargoHash = "sha256-QAjTD1s6DJ5ASgUtVBJcBc1WdLTn+8n3OZYi5isc62g=";

  # The upstream vendor was generated on a non-Linux platform
  buildNoDefaultFeatures = true;

  checkFlags = [
    # Test tries to extract an .apkm archive
    "--skip=session::tests::apkm_extract_picks_base_apk"
  ];

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
