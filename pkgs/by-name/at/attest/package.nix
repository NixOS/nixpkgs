{
  fetchFromGitHub,
  rustPlatform,
  lib,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "attest";
  version = "0.4.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fossable";
    repo = "attest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rHlnEbl6Z0Tch7JiF5aNTVgsEZ00sUjfYAMrGTcDAdI=";
  };

  cargoHash = "sha256-DGrrV2y5Gv0HKk2d+/MB+Kn86hVZdiCNXS5QNFCMqkg=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "attest";
    description = "Dead simple test framework for the age of AI";
    homepage = "https://github.com/fossable/attest";
    license = lib.licenses.unlicense;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ cilki ];
  };
})
