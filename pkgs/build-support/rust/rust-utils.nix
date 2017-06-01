{ lib, buildPlatform, stdenv }:

let buildCrate = { crateName, crateVersion, dependencies, complete, crateFeatures, libName, build, release, libPath, crateType, metadata, crateBin, finalBins }:

      let depsDir = builtins.foldl' (deps: dep: deps + " " + dep.out) "" dependencies;
          completeDepsDir = builtins.foldl' (deps: dep: deps + " " + dep.out) "" complete;
          deps =
            builtins.foldl' (deps: dep:
              let extern = lib.strings.replaceStrings ["-"] ["_"] dep.libName; in
              deps + (if dep.crateType == "lib" then
                 " --extern ${extern}=${dep.out}/lib${extern}-${dep.metadata}.rlib"
              else
                 " --extern ${extern}=${dep.out}/lib${extern}-${dep.metadata}.so")
            ) "" dependencies;
          optLevel = if release then 3 else 0;
          rustcOpts = (if release then "-C opt-level=3" else "-g");
          rustcMeta = "-C metadata=" + metadata + " -C extra-filename=-" + metadata;
      in ''
      mkdir -p target/deps
      mkdir -p target/build
      chmod uga+w target -R

      for i in ${completeDepsDir}; do
         ln -s -f $i/*.rlib target/deps #*/
         ln -s -f $i/*.so target/deps #*/
         if [ -e "$i/link" ]; then
            cat $i/link >> target/link
            cat $i/link >> target/link.final
         fi
      done

      EXTRA_BUILD=""
      BUILD_OUT_DIR=""
      export CARGO_PKG_NAME=${crateName}
      export CARGO_PKG_VERSION=${crateVersion}
      export CARGO_CFG_TARGET_ARCH=$(echo ${buildPlatform.system} | sed -e "s/\([^-]*\)-\([^-]*\)/\1/")
      export CARGO_CFG_TARGET_OS=$(echo ${buildPlatform.system} | sed -e "s/\([^-]*\)-\([^-]*\)/\2/")

      export CARGO_CFG_TARGET_ENV="gnu"
      export CARGO_MANIFEST_DIR="."
      export DEBUG="${toString (!release)}"
      export OPT_LEVEL="${toString optLevel}"
      export TARGET="${buildPlatform.system}-gnu"
      export HOST="${buildPlatform.system}-gnu"
      export PROFILE=${if release then "release" else "debug"}
      export OUT_DIR=$(pwd)/target/build/${crateName}.out

      if [[ ! -z "${build}" ]] ; then
         echo "Building ${build}"
         mkdir -p target/build/${crateName}
         rustc --crate-name build_script_build ${build} --crate-type bin ${rustcOpts} ${crateFeatures} --out-dir target/build/${crateName} --emit=dep-info,link -L dependency=target/deps ${deps} --cap-lints allow
         mkdir -p target/build/${crateName}.out
         export RUST_BACKTRACE=1
         BUILD_OUT_DIR="-L $OUT_DIR"
         mkdir -p $OUT_DIR
         target/build/${crateName}/build_script_build > target/build/${crateName}.opt
         set +e
         EXTRA_BUILD=$(grep "^cargo:rustc-flags=" target/build/${crateName}.opt | sed -e "s/cargo:rustc-flags=\(.*\)/\1/")
         EXTRA_FEATURES=$(grep "^cargo:rustc-cfg=" target/build/${crateName}.opt | sed -e "s/cargo:rustc-cfg=\(.*\)/--cfg \1/")

         EXTRA_LINK=$(grep "^cargo:rustc-link-lib=" target/build/${crateName}.opt | sed -e "s/cargo:rustc-link-lib=\(.*\)/\1/")
         EXTRA_LINK_SEARCH=$(grep "^cargo:rustc-link-search=" target/build/${crateName}.opt | sed -e "s/cargo:rustc-link-search=\(.*\)/\1/")
         set -e
         if [ -n "$(ls target/build/${crateName}.out)" ]; then

            if [ -e "${libPath}" ] ; then
               cp -r target/build/${crateName}.out/* $(dirname ${libPath}) #*/
            else
               cp -r target/build/${crateName}.out/* src #*/
            fi
         fi
      fi
      # echo "Features: ${crateFeatures}" $EXTRA_FEATURES

      EXTRA_LIB=""
      CRATE_NAME=$(echo ${libName} | sed -e "s/-/_/g")
      # echo "Libname" ${libName} ${libPath}
      # echo "Deps: ${deps}"
      if [ -e "${libPath}" ] ; then

         echo "Building ${libPath}"
         rustc --crate-name $CRATE_NAME ${libPath} --crate-type ${crateType} ${rustcOpts} ${rustcMeta} ${crateFeatures} --out-dir target/deps --emit=dep-info,link -L dependency=target/deps ${deps} --cap-lints allow $BUILD_OUT_DIR $EXTRA_BUILD $EXTRA_FEATURES
         EXTRA_LIB=" --extern $CRATE_NAME=target/deps/lib$CRATE_NAME-${metadata}.rlib"

      elif [ -e src/lib.rs ] ; then

         echo "Building src/lib.rs"
         rustc --crate-name $CRATE_NAME src/lib.rs --crate-type ${crateType} ${rustcOpts} ${rustcMeta} ${crateFeatures} --out-dir target/deps --emit=dep-info,link -L dependency=target/deps ${deps} --cap-lints allow $BUILD_OUT_DIR $EXTRA_BUILD $EXTRA_FEATURES
         EXTRA_LIB=" --extern $CRATE_NAME=target/deps/lib$CRATE_NAME-${metadata}.rlib"

      elif [ -e src/${libName}.rs ] ; then

         echo "Building src/${libName}.rs"
         rustc --crate-name $CRATE_NAME src/${libName}.rs --crate-type ${crateType} ${rustcOpts} ${rustcMeta} ${crateFeatures} --out-dir target/deps --emit=dep-info,link -L dependency=target/deps ${deps} --cap-lints allow $BUILD_OUT_DIR $EXTRA_BUILD $EXTRA_FEATURES
         EXTRA_LIB=" --extern $CRATE_NAME=target/deps/lib$CRATE_NAME-${metadata}.rlib"

      fi

      echo "$EXTRA_LINK_SEARCH" | while read i; do
         if [ ! -z "$i" ]; then
           echo "-L $i" >> target/link
           L=$(echo $i | sed -e "s#target/build#$out#")
           echo "-L $L" >> target/link.final
         fi
      done
      echo "$EXTRA_LINK" | while read i; do
         if [ ! -z "$i" ]; then
           echo "-l $i" >> target/link
           echo "-l $i" >> target/link.final
         fi
      done

      if [ -e target/link ]; then
         LINK=$(cat target/link)
      fi

      mkdir -p target/bin
      echo "${crateBin}" | sed -n 1'p' | tr ',' '\n' | while read BIN; do
         if [ ! -z "$BIN" ]; then
           echo "Building $BIN"
           rustc --crate-name $BIN --crate-type bin ${rustcOpts} ${crateFeatures} --out-dir target/bin --emit=dep-info,link -L dependency=target/deps $LINK ${deps}$EXTRA_LIB --cap-lints allow $BUILD_OUT_DIR $EXTRA_BUILD $EXTRA_FEATURES
         fi
      done
      if [[ (-z "${crateBin}") && (-e src/main.rs) ]]; then
         echo "Building src/main.rs"
         rustc --crate-name $CRATE_NAME src/main.rs --crate-type bin ${rustcOpts} ${crateFeatures} --out-dir target/bin --emit=dep-info,link -L dependency=target/deps $LINK ${deps}$EXTRA_LIB --cap-lints allow $BUILD_OUT_DIR $EXTRA_BUILD $EXTRA_FEATURES
      fi
    '' + finalBins;

    installCrate = crateName: ''
      mkdir -p $out
      if [ -e target/link.final ]; then
        cp target/link.final $out/link
      fi
      cp -PR target/deps/* $out # */
      if [ "$(ls -A target/build)" ]; then # */
        cp -PR target/build/* $out # */
      fi
      if [ "$(ls -A target/bin)" ]; then # */
        mkdir -p $out/bin
        cp -P target/bin/* $out/bin # */
      fi
    '';
in

crate: rust: stdenv.mkDerivation rec {

    inherit (crate) crateName src;

    release = if crate ? release then crate.release else false;
    name = "rust_${crate.crateName}-${crate.version}";
    buildInputs = [ rust ] ++ (lib.attrByPath ["buildInputs"] [] crate);
    dependencies = builtins.map (dep: dep rust) (lib.attrByPath ["dependencies"] [] crate);

    complete = builtins.foldl' (comp: dep: if lib.lists.any (x: x == comp) dep.complete then comp ++ dep.complete else comp) dependencies dependencies;

    crateFeatures = if crate ? features then
       builtins.foldl' (features: f: features + " --cfg feature=\\\"${f}\\\"") "" crate.features
    else "";

    libName = if crate ? libName then crate.libName else crate.crateName;
    libPath = if crate ? libPath then crate.libPath else "";

    metadata = builtins.substring 0 10 (builtins.hashString "sha256" (crateName + "-" + crateVersion));

    crateBin = if crate ? crateBin then
       builtins.foldl' (bins: bin:
          let name =
              lib.strings.replaceStrings ["-"] ["_"]
                 (if bin ? name then bin.name else crateName);
              path = if bin ? path then bin.path else "src/main.rs";
          in
          bins + (if bin == "" then "" else ",") + "${name} ${path}"

       ) "" crate.crateBin
    else "";

    finalBins = if crate ? crateBin then
       builtins.foldl' (bins: bin:
          let name = lib.strings.replaceStrings ["-"] ["_"]
                      (if bin ? name then bin.name else crateName);
              new_name = if bin ? name then bin.name else crateName;
          in
          if name == new_name then bins else
          (bins + "mv target/bin/${name} target/bin/${new_name};")

       ) "" crate.crateBin
    else "";

    build = if crate ? build then crate.build else "";
    crateVersion = crate.version;
    crateType = if crate ? procMacro then if crate.procMacro then "proc-macro" else "lib" else "lib";
    buildPhase = buildCrate { inherit crateName dependencies complete crateFeatures libName build release libPath crateType crateVersion metadata crateBin finalBins; };
    installPhase = installCrate crateName;
}
