{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "apkscope";
  version = "0.13.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "suffixing";
    repo = "apkscope";
    tag = "v${finalAttrs.version}";
    hash = "sha256-81Rm0VIrIA7D+AlPddez3drbEcK869H56Twh5ehcmYA=";
  };

  cargoHash = "sha256-ka/Qca7Xps/XqR8uP65TmLJw+kG7X2yXIeftsJgUaAs=";

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
