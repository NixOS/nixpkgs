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
      version = "0.25.0";
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
              hash = "sha256-L9jm94Epb22hYsU3hoq1lZXb5aFVD4FC4x2qNt0DljA=";
            };
            vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
          }
        );
    };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "coc-texlab";
  version = "0-unstable-2025-07-22";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-texlab";
    rev = "a4ad3f259d94086f4971b22b97833e8a72226782";
    hash = "sha256-6W+L/LdF6g0Xwhv+9VtjjfzRjlbN7OaqHbSXtO3cfZ0=";
  };

  yarnOfflineCache = fetchYarnDeps {
    inherit (finalAttrs) src;
    hash = "sha256-g2IwfO1IMktTtflR2m7c99wOYLJYmD2I7hBbCNy+XFA=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    nodejs
    esbuild'
  ];

  env.ESBUILD_BINARY_PATH = lib.getExe esbuild';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "TexLab extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-texlab";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
