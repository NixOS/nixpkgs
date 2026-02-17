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
  version = "0-unstable-2026-01-28";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-texlab";
    rev = "b31f2e761bcc9add3f10ef926b1b7bd3d7eb634c";
    hash = "sha256-5HnoNVECMtqW3ZtSblGE6vSE2tEVvM99oIwdVRtK108=";
  };

  yarnOfflineCache = fetchYarnDeps {
    inherit (finalAttrs) src;
    hash = "sha256-EjLjtluJZpueWb3+2vWwUXrG6DOHjmdkTm8yzWbiDkQ=";
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
    maintainers = [ ];
  };
})
