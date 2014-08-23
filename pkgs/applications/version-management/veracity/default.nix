x@{builderDefsPackage
  , cmake, curl, patch, zlib, icu, sqlite, libuuid
  , readline, openssl, spidermonkey_1_8_0rc1
  , nspr, nss
  , unzip, glibcLocales
  , runTests ? false
  , ...}:
builderDefsPackage
(a :  
let 
  s = import ./src-for-default.nix;
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    ["runTests"];
  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
    
in
rec {
  src = a.fetchUrlFromSrcInfo s;

  inherit (s) name;
  inherit buildInputs;

  phaseNames = ["prepare_sgneeds" "dump0" "prepareMakefiles" "fixPaths" "doMake" "doTest" "doDeploy"];

  dump0 = (a.doDump "0");

  runTests = a.stdenv.lib.attrByPath ["runTests"] false a;

  doTest = a.fullDepEntry (if runTests then ''
    mkdir pseudo-home
    export HOME=$PWD/pseudo-home
    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8
    ${if a.stdenv.isLinux then "export LOCALE_ARCHIVE=${a.glibcLocales}/lib/locale/locale-archive;" else ""}
    make test || true
  '' else "") ["doMake" "minInit"];

  prepare_sgneeds = a.fullDepEntry (''
    mkdir -p "$out/sgneeds/include/spidermonkey"
    for d in bin include lib; do 
      mkdir -p "$out/sgneeds/$d"
      mkdir -p "$out/sgneeds/$d"
      for p in "${spidermonkey_1_8_0rc1}"; do
        for f in "$p"/"$d"/*; do
	  ln -sf "$f" "$out"/sgneeds/"$d"
	done
      done
    done
      for p in  "${spidermonkey_1_8_0rc1}/include" "${spidermonkey_1_8_0rc1}/include/js"; do
        for f in "$p"/*; do
	  ln -sf "$f" "$out"/sgneeds/include/spidermonkey/
	done
      done

    mkdir -p "$out/sgneeds/include/sgbrings"
    ln -s "$out/sgneeds/include/js" "$out/sgneeds/include/sgbrings/js"
    for f in "$out/sgneeds/lib/"libjs*; do
      bn="$(basename "$f")"
      ln -s "$f" "$out/sgneeds/lib/''${bn/libjs/libsgbrings_js}"
    done

    export SGNEEDS_DIR="$out"/sgneeds/
    export VVTHIRDPARTY="$out"/sgneeds/

    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I"$out/sgneeds/include" -Wno-error"
  '') ["minInit" "defEnsureDir"];

  prepareMakefiles = a.fullDepEntry ''
    sed -e 's@ /bin/uname @ uname @g' -i CMakeLists.txt
    sed -e 's@ /bin/uname @ uname @g' -i common-CMakeLists.txt
    cd ..
    mkdir build
    cd build
    export NIX_LDFLAGS="$NIX_LDFLAGS -lssl"
    cmake -G "Unix Makefiles" -D SGNEEDS_DIR="$SGNEEDS_DIR" -D VVTHIRDPARTY="$VVTHIRDPARTY" -D SPIDERMONKEY_INCDIR="${a.spidermonkey_1_8_0rc1}/include" -D SPIDERMONKEY_LIB="${a.spidermonkey_1_8_0rc1}/lib/libjs.so" ../veracity*
  '' ["minInit" "addInputs" "doUnpack"];

  fixPaths = a.fullDepEntry ''
    sed -e "s@/bin/bash@${a.stdenv.shell}@" -i $(find .. -type f)
    sed -e 's@/bin/ln@#{a.coreutils}/bin/ln@g' -i ../veracity/src/js_tests/*.js
    sed -e 's@/usr/bin/gdb@#{a.gdb}/bin/gdb@g' -i ../veracity/testsuite/c_test.sh
    sed -e 's@"/bin/@"@g' -i ../veracity/testsuite/u*.c
  '' ["minInit"];

  doDeploy = a.fullDepEntry ''
    mkdir -p "$out/bin" "$out/share/veracity/"
    cp -r .. "$out/share/veracity/build-dir"
    ln -s "$out/share/veracity/build-dir/build/src/cmd/vv" "$out/bin"
    ln -s "$out/share/veracity/build-dir/build/src/script/vscript" "$out/bin"
    ${if runTests then "" else '' 
      rm -rf  "$out/share/veracity/build-dir/veracity/testsuite" 
      rm -rf  "$out/share/veracity/build-dir/build/testsuite" 
    ''}
  '' ["doMake" "minInit" "defEnsureDir"];

  meta = {
    description = "A distributed version control system with template-based merging";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux ;
    broken = true;
  };
}) x

