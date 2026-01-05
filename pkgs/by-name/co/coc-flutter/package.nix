{
  lib,
  stdenv,
  esbuild,
  buildGoModule,
  yarnBuildHook,
  yarnInstallHook,
  yarnConfigHook,
  nodejs,
  fetchYarnDeps,
  fetchFromGitHub,
  nix-update-script,
}:
let
  esbuild' =
    let
      version = "0.9.0";
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
              hash = "sha256-+4oNM39cN7zCld4WwLVDHQFyvVhdsqKTLLiF2a9+KP0=";
            };
            vendorHash = "sha256-2ABWPqhK2Cf4ipQH7XvRrd+ZscJhYPc3SV2cGT0apdg=";
          }
        );
    };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "coc-flutter";
  version = "1.9.3-unstable-2023-03-22";

  src = fetchFromGitHub {
    owner = "iamcco";
    repo = "coc-flutter";
    rev = "883c269eaacbeddbd4fb08e32e6a05051933429d";
    hash = "sha256-K3NvqZnAEj/qfsvomYl7dPtEo3ad7w1dCfZHjMRwbAA=";
  };

  yarnOfflineCache = fetchYarnDeps {
    inherit (finalAttrs) src;
    hash = "sha256-aEjfhjkMlHSdISfG9baRfaUiTUbj8TPZi2edAFiqKlg=";
  };

  nativeBuildInputs = [
    yarnBuildHook
    yarnConfigHook
    yarnInstallHook
    nodejs
    esbuild'
  ];

  env.ESBUILD_BINARY_PATH = lib.getExe esbuild';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Flutter support for (Neo)vim";
    homepage = "https://github.com/iamcco/coc-flutter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
