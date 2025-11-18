{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  nodejs,
  nix-update-script,
  esbuild,
  buildGoModule,
}:
let
  esbuild' =
    let
      version = "0.12.22";
    in
    esbuild.override {
      buildGoModule =
        args:
        buildGoModule (
          args
          // {
            inherit version;
            src = fetchFromGitHub {
              owner = "evanw";
              repo = "esbuild";
              rev = "v${version}";
              hash = "sha256-vZlrHfcXOz4QHTH9otpwtPIWHGxK4TAol5o/Tl0M98E=";
            };
            vendorHash = "sha256-2ABWPqhK2Cf4ipQH7XvRrd+ZscJhYPc3SV2cGT0apdg=";
          }
        );
    };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "coc-smartf";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc-smartf";
    tag = finalAttrs.version;
    hash = "sha256-CL0jWwMj6sFXEx+D1Orc4Fivbl33qE2P3yRJB0qqQFQ=";
  };

  yarnOfflineCache = fetchYarnDeps {
    inherit (finalAttrs) src;
    hash = "sha256-s1TStKyDPydBxMLfszhKHGyQeFIC6bDPtssNm9hdZNs=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    nodejs
    esbuild'
  ];

  env.ESBUILD_BINARY_PATH = lib.getExe esbuild';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Make jump to character easier";
    homepage = "https://github.com/neoclide/coc-smartf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
