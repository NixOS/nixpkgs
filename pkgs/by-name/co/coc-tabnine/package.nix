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
      version = "0.8.33";
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
              hash = "sha256-u/3YHQZskgbkaXV7RF8G9kMMx1A25hHhHv+VQdZZ4EU=";
            };
            vendorHash = "sha256-2ABWPqhK2Cf4ipQH7XvRrd+ZscJhYPc3SV2cGT0apdg=";
          }
        );
    };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "coc-tabnine";
  version = "1.3.7";

  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc-tabnine";
    tag = finalAttrs.version;
    hash = "sha256-7l4gCpArP1pp/SfYiyzjLc8VH7HVhwx2slorQcuA6k4=";
  };

  yarnOfflineCache = fetchYarnDeps {
    inherit (finalAttrs) src;
    hash = "sha256-Pg/AQv9/VTUXTu6q71vQ+0AMNswHEoCOAWnWIeuy/lQ=";
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
    description = "Tabnine extension for coc.nvim";
    homepage = "https://github.com/neoclide/coc-tabnine";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
