{ lib, makeWrapper, buildEnv, compiler-explorer, compiler-explorer-compilers, callPackage, nodejs }:
let
 
 gcc = if builtins.hasAttr "gcc" 
                 compiler-explorer-compilers
              then compiler-explorer.compilers.gcc else [];
 clang = if builtins.hasAttr "clang" 
                 compiler-explorer-compilers
              then compiler-explorer.compilers.clang else [];

in
buildEnv {
  name = "${compiler-explorer.name}-env";

  nativeBuildInputs = [ makeWrapper ];
  paths = [ compiler-explorer ];
  postBuild = ''
    installed=${compiler-explorer}/lib/node_modules/compiler-explorer
    mkdir -p $out/bin
    makeWrapper ${nodejs}/bin/node $out/bin/compiler-explorer \
      --chdir $installed/out/dist \
      --set NODE_ENV production \
      --set-default COMPILER_EXPLORER_ETC ${compiler-explorer}/etc \
      --add-flags $installed/out/dist/app.js \
      --add-flags --dist \
      --add-flags "--webpackContent $installed/out/webpack/static" \
      --add-flags "--env nix" \
      --add-flags '--rootDir $COMPILER_EXPLORER_ETC'
  '';

}