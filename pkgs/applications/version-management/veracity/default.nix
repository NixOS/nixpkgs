x@{builderDefsPackage
  , cmake, curl, patch, zlib, icu, sqlite, libuuid
  , readline, openssl, spidermonkey_1_8_0rc1
  , ...}:
builderDefsPackage
(a :  
let 
  s = import ./src-for-default.nix;
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];
  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
    
in
rec {
  src = a.fetchUrlFromSrcInfo s;

  inherit (s) name;
  inherit buildInputs;

  phaseNames = ["prepareMakefiles" "doMake" "doDeploy"];

  prepareMakefiles = a.fullDepEntry ''
    find src -type f -exec sed -e 's@#include \([<"]\)sgbrings/js/js@#include \1js/js@g' -i '{}' ';'
    cd ..
    mkdir build
    cd build
    export NIX_LDFLAGS="$NIX_LDFLAGS -lssl"
    cmake -G "Unix Makefiles" -D SGBRINGS_JS_INCDIR="${spidermonkey_1_8_0rc1}/include" -D SGBRINGS_JS_LIB="${spidermonkey_1_8_0rc1}/lib/libjs.a" ../veracity*
  '' ["minInit" "addInputs" "doUnpack"];

  doDeploy = a.fullDepEntry ''
    ensureDir "$out/bin" "$out/share/veracity/"
    cp -r .. "$out/share/veracity/build-dir"
    ln -s "$out/share/veracity/build-dir/build/src/cmd/vv" "$out/bin"
    ln -s "$out/share/veracity/build-dir/build/src/script/vscript" "$out/bin"
  '' ["doMake" "minInit" "defEnsureDir"];

  meta = {
    description = "A distributed version control system with template-based merging";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux ;
  };
}) x

