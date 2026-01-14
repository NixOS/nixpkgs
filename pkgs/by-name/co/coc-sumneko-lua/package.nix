{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  esbuild,
  buildGoModule,
}:
let
  esbuild' =
    let
      version = "0.20.2";
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
              hash = "sha256-h/Vqwax4B4nehRP9TaYbdixAZdb1hx373dNxNHvDrtY=";
            };
            vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
          }
        );
    };
in
buildNpmPackage (finalAttrs: {
  pname = "coc-sumneko-lua";
  version = "0.0.42";

  src = fetchFromGitHub {
    owner = "xiyaowong";
    repo = "coc-sumneko-lua";
    tag = "v${finalAttrs.version}";
    hash = "sha256-B5XvhhBbVeBQI6nWVskaopx2pJYFBiFCfbPwwwloFig=";
  };

  patches = [
    ./package-lock-fix.patch
  ];

  npmDepsHash = "sha256-NEUDQm4hzhGJyEdiBBrSWa8fMw3DcnnPJJo0m+HgZ5U=";

  nativeBuildInputs = [ esbuild' ];

  env.ESBUILD_BINARY_PATH = lib.getExe esbuild';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Lua extension using sumneko lua-language-server for coc.nvim";
    homepage = "https://github.com/xiyaowong/coc-sumneko-lua";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
