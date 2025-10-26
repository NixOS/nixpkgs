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
  version = "0-unstable-2026-03-07";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-texlab";
    rev = "104bbcdd5fbed16f765eb515fa0e0648d65879fe";
    hash = "sha256-G/SI/RwT5S8xNFSP5JTZI6tFbBN6LoE38CENTDZdQqo=";
  };

  yarnOfflineCache = fetchYarnDeps {
    inherit (finalAttrs) src;
    hash = "sha256-/cZaAIbQ/A87NE6FPhkyy8Junvd4MEdF7yfRKrS4vFM=";
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
