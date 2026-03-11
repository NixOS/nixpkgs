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
  version = "0-unstable-2026-02-20";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-texlab";
    rev = "6f66fe9326532cee43a6f76f4dcd3917e43bf23c";
    hash = "sha256-HQyxQGOzx2Yj80P6Rp8kI4GE55b+O599y/4/CvSvQJ0=";
  };

  yarnOfflineCache = fetchYarnDeps {
    inherit (finalAttrs) src;
    hash = "sha256-7r34jFRxiircFUe/LHrW/Ibjd6KR4YLXUoGmiQhFa5g=";
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
