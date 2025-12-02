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
      version = "0.8.29";
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
              hash = "sha256-WpnWdx0Oi1KBWiS/CEd88hYU/3ka1x1AA71ipYJgT5A=";
            };
            vendorHash = "sha256-2ABWPqhK2Cf4ipQH7XvRrd+ZscJhYPc3SV2cGT0apdg=";
          }
        );
    };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "coc-solargraph";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc-solargraph";
    tag = finalAttrs.version;
    hash = "sha256-AUulj0tcgkXrQS9k1zhB0LKWJxvIlVtxSQK+nYGm73s=";
  };

  yarnOfflineCache = fetchYarnDeps {
    inherit (finalAttrs) src;
    hash = "sha256-FPxvwqx7TfJBM+O8TY64swJVYlWIbCvVbzVJYthHjO0=";
  };

  yarnBuildScript = "prepare";

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
    description = "Solargraph extension for coc.nvim";
    homepage = "https://github.com/neoclide/coc-solargraph";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
