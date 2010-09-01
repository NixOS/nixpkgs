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

  phaseNames = ["prepare_sgneeds" "dump0" "prepareMakefiles" "doMake" "doDeploy"];

  dump0 = (a.doDump "0");

  prepare_sgneeds = a.fullDepEntry (''
    for d in bin include lib; do 
      ensureDir "$out/sgneeds/$d"
      for p in "${spidermonkey_1_8_0rc1}"; do
        for f in "$p"/"$d"/*; do
	  ln -sf "$f" "$out"/sgneeds/"$d"
	done
      done
    done

    ensureDir "$out/sgneeds/include/sgbrings"
    ln -s "$out/sgneeds/include/js" "$out/sgneeds/include/sgbrings/js"
    for f in "$out/sgneeds/lib/"libjs*; do
      bn="$(basename "$f")"
      ln -s "$f" "$out/sgneeds/lib/''${bn/libjs/libsgbrings_js}"
    done

    export SGNEEDS_DIR="$out"/sgneeds/
  '') ["minInit" "defEnsureDir"];

  prepareMakefiles = a.fullDepEntry ''
    cd ..
    mkdir build
    cd build
    export NIX_LDFLAGS="$NIX_LDFLAGS -lssl"
    cmake -G "Unix Makefiles" -D SGNEEDS_DIR="$SGNEEDS_DIR" ../veracity*
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

