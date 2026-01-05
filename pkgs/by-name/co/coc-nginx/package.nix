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
      version = "0.16.17";
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
              hash = "sha256-8L8h0FaexNsb3Mj6/ohA37nYLFogo5wXkAhGztGUUsQ=";
            };
            vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
          }
        );
    };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "coc-nginx";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "yaegassy";
    repo = "coc-nginx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9dca1YUQZCbzmGe+9qVJABCWZCGUUZDvtznMQEP/CCQ=";
  };

  yarnOfflineCache = fetchYarnDeps {
    inherit (finalAttrs) src;
    hash = "sha256-CBw2E93EWmBOCppj1gxYuAynHBZDJBPh58X099TP5mE=";
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
    description = "nginx-language-server extension for coc.nvim";
    homepage = "https://github.com/yaegassy/coc-nginx";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
