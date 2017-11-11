# Code for buildRustCrate, a Nix function that builds Rust code, just
# like Cargo, but using Nix instead.
#
# This can be useful for deploying packages with NixOps, and to share
# binary dependencies between projects.

{ lib, buildPlatform, stdenv, pkgs }:

let buildCrate = { crateName, crateVersion, buildDependencies, dependencies,
                   completeDeps, completeBuildDeps,
                   crateFeatures, libName, build, release, libPath,
                   crateType, metadata, crateBin, finalBins,
                   verboseBuild, colors }:

      let depsDir = lib.concatStringsSep " " dependencies;
          completeDepsDir = lib.concatStringsSep " " completeDeps;
          completeBuildDepsDir = lib.concatStringsSep " " completeBuildDeps;
          makeDeps = dependencies:
            (lib.concatMapStringsSep " " (dep:
              let extern = lib.strings.replaceStrings ["-"] ["_"] dep.libName; in
              (if dep.crateType == "lib" then
                 " --extern ${extern}=${dep.out}/lib${extern}-${dep.metadata}.rlib"
              else
                 " --extern ${extern}=${dep.out}/lib${extern}-${dep.metadata}.so")
            ) dependencies);
          deps = makeDeps dependencies;
          buildDeps = makeDeps buildDependencies;
          optLevel = if release then 3 else 0;
          rustcOpts = (if release then "-C opt-level=3" else "-C debuginfo=2");
          rustcMeta = "-C metadata=${metadata} -C extra-filename=-${metadata}";
      in ''
      norm=""
      bold=""
      green=""
      boldgreen=""
      if [[ "${colors}" -eq "always" ]]; then
        norm="$(printf '\033[0m')" #returns to "normal"
        bold="$(printf '\033[0;1m')" #set bold
        green="$(printf '\033[0;32m')" #set green
        boldgreen="$(printf '\033[0;1;32m')" #set bold, and set green.
      fi

      mkdir -p target/deps
      mkdir -p target/build
      mkdir -p target/buildDeps
      chmod uga+w target -R
      for i in ${completeDepsDir}; do
         ln -s -f $i/*.rlib target/deps #*/
         ln -s -f $i/*.so target/deps #*/
         if [ -e "$i/link" ]; then
            cat $i/link >> target/link
            cat $i/link >> target/link.final
         fi
         if [ -e $i/env ]; then
            source $i/env
         fi
      done
      for i in ${completeBuildDepsDir}; do
         ln -s -f $i/*.rlib target/buildDeps #*/
         ln -s -f $i/*.so target/buildDeps #*/
         if [ -e "$i/link" ]; then
            cat $i/link >> target/link.build
         fi
         if [ -e $i/env ]; then
            source $i/env
         fi
      done
      if [ -e target/link ]; then
        sort -u target/link > target/link.sorted
        mv target/link.sorted target/link
        sort -u target/link.final > target/link.final.sorted
        mv target/link.final.sorted target/link.final
        tr '\n' ' ' < target/link > target/link_
      fi
      EXTRA_BUILD=""
      BUILD_OUT_DIR=""
      export CARGO_PKG_NAME=${crateName}
      export CARGO_PKG_VERSION=${crateVersion}
      export CARGO_CFG_TARGET_ARCH=${buildPlatform.parsed.cpu.name}
      export CARGO_CFG_TARGET_OS=${buildPlatform.parsed.kernel.name}

      export CARGO_CFG_TARGET_ENV="gnu"
      export CARGO_MANIFEST_DIR="."
      export DEBUG="${toString (!release)}"
      export OPT_LEVEL="${toString optLevel}"
      export TARGET="${buildPlatform.config}"
      export HOST="${buildPlatform.config}"
      export PROFILE=${if release then "release" else "debug"}
      export OUT_DIR=$(pwd)/target/build/${crateName}.out

      BUILD=""
      if [[ ! -z "${build}" ]] ; then
         BUILD=${build}
      elif [[ -e "build.rs" ]]; then
         BUILD="build.rs"
      fi
      if [[ ! -z "$BUILD" ]] ; then
         echo "$boldgreen""Building $BUILD (${libName})""$norm"
         mkdir -p target/build/${crateName}
         EXTRA_BUILD_FLAGS=""
         if [ -e target/link_ ]; then
           EXTRA_BUILD_FLAGS=$(cat target/link_)
         fi
         if [ -e target/link.build ]; then
           EXTRA_BUILD_FLAGS="$EXTRA_BUILD_FLAGS $(cat target/link.build)"
         fi
         if ${verboseBuild}; then
           echo $boldgreen""Running$norm rustc --crate-name build_script_build $BUILD --crate-type bin ${rustcOpts} ${crateFeatures} --out-dir target/build/${crateName} --emit=dep-info,link -L dependency=target/buildDeps ${buildDeps} --cap-lints allow $EXTRA_BUILD_FLAGS
         fi
         rustc --crate-name build_script_build $BUILD --crate-type bin ${rustcOpts} \
           ${crateFeatures} --out-dir target/build/${crateName} --emit=dep-info,link \
           -L dependency=target/buildDeps ${buildDeps} --cap-lints allow $EXTRA_BUILD_FLAGS --color ${colors}

         mkdir -p target/build/${crateName}.out
         export RUST_BACKTRACE=1
         BUILD_OUT_DIR="-L $OUT_DIR"
         mkdir -p $OUT_DIR
         target/build/${crateName}/build_script_build > target/build/${crateName}.opt
         set +e
         EXTRA_BUILD=$(sed -n "s/^cargo:rustc-flags=\(.*\)/\1/p" target/build/${crateName}.opt | tr '\n' ' ')
         EXTRA_FEATURES=$(sed -n "s/^cargo:rustc-cfg=\(.*\)/--cfg \1/p" target/build/${crateName}.opt | tr '\n' ' ')
         EXTRA_LINK=$(sed -n "s/^cargo:rustc-link-lib=\(.*\)/\1/p" target/build/${crateName}.opt | tr '\n' ' ')
         EXTRA_LINK_SEARCH=$(sed -n "s/^cargo:rustc-link-search=\(.*\)/\1/p" target/build/${crateName}.opt | tr '\n' ' ')
         CRATENAME=$(echo ${crateName} | sed -e "s/\(.*\)-sys$/\1/" | tr '[:lower:]' '[:upper:]')
         grep -P "^cargo:(?!(rustc-|warning=|rerun-if-changed=|rerun-if-env-changed))" target/build/${crateName}.opt \
           | sed -e "s/cargo:\([^=]*\)=\(.*\)/export DEP_$(echo $CRATENAME)_\U\1\E=\2/" > target/env

         set -e
         if [ -n "$(ls target/build/${crateName}.out)" ]; then

            if [ -e "${libPath}" ] ; then
               cp -r target/build/${crateName}.out/* $(dirname ${libPath}) #*/
            else
               cp -r target/build/${crateName}.out/* src #*/
            fi
         fi
      fi

      EXTRA_LIB=""
      CRATE_NAME=$(echo ${libName} | sed -e "s/-/_/g")

      if [ -e target/link_ ]; then
        EXTRA_BUILD="$(cat target/link_) $EXTRA_BUILD"
      fi

      if [ -e "${libPath}" ] ; then

         if ${verboseBuild}; then
           echo $boldgreen""Building ${libPath}$norm rustc --crate-name $CRATE_NAME ${libPath} --crate-type ${crateType} ${rustcOpts} ${rustcMeta} ${crateFeatures} --out-dir target/deps --emit=dep-info,link -L dependency=target/deps ${deps} --cap-lints allow $BUILD_OUT_DIR $EXTRA_BUILD $EXTRA_FEATURES
         fi
         rustc --crate-name $CRATE_NAME ${libPath} --crate-type ${crateType} \
           ${rustcOpts} ${rustcMeta} ${crateFeatures} --out-dir target/deps \
           --emit=dep-info,link -L dependency=target/deps ${deps} --cap-lints allow \
           $BUILD_OUT_DIR $EXTRA_BUILD $EXTRA_FEATURES --color ${colors}

         EXTRA_LIB=" --extern $CRATE_NAME=target/deps/lib$CRATE_NAME-${metadata}.rlib"
         if [ -e target/deps/lib$CRATE_NAME-${metadata}.so ]; then
            EXTRA_LIB="$EXTRA_LIB --extern $CRATE_NAME=target/deps/lib$CRATE_NAME-${metadata}.so"
         fi
      elif [ -e src/lib.rs ] ; then

         echo "$boldgreen""Building src/lib.rs (${libName})""$norm"

         if ${verboseBuild}; then
           echo $boldgreen""Running$norm rustc --crate-name $CRATE_NAME src/lib.rs --crate-type ${crateType} ${rustcOpts} ${rustcMeta} ${crateFeatures} --out-dir target/deps --emit=dep-info,link -L dependency=target/deps ${deps} --cap-lints allow $BUILD_OUT_DIR $EXTRA_BUILD $EXTRA_FEATURES
         fi
         rustc --crate-name $CRATE_NAME src/lib.rs --crate-type ${crateType} \
           ${rustcOpts} ${rustcMeta} ${crateFeatures} --out-dir target/deps \
           --emit=dep-info,link -L dependency=target/deps ${deps} --cap-lints allow \
           $BUILD_OUT_DIR $EXTRA_BUILD $EXTRA_FEATURES --color ${colors}

         EXTRA_LIB=" --extern $CRATE_NAME=target/deps/lib$CRATE_NAME-${metadata}.rlib"
         if [ -e target/deps/lib$CRATE_NAME-${metadata}.so ]; then
            EXTRA_LIB="$EXTRA_LIB --extern $CRATE_NAME=target/deps/lib$CRATE_NAME-${metadata}.so"
         fi

      elif [ -e src/${libName}.rs ] ; then

         echo "$boldgreen""Building src/${libName}.rs""$norm"
         if ${verboseBuild}; then
           echo $boldgreen""Running$norm rustc --crate-name $CRATE_NAME src/${libName}.rs --crate-type ${crateType} ${rustcOpts} ${rustcMeta} ${crateFeatures} --out-dir target/deps --emit=dep-info,link -L dependency=target/deps ${deps} --cap-lints allow $BUILD_OUT_DIR $EXTRA_BUILD $EXTRA_FEATURES
         fi
         rustc --crate-name $CRATE_NAME src/${libName}.rs --crate-type ${crateType} \
           ${rustcOpts} ${rustcMeta} ${crateFeatures} --out-dir target/deps \
           --emit=dep-info,link -L dependency=target/deps ${deps} --cap-lints allow \
           $BUILD_OUT_DIR $EXTRA_BUILD $EXTRA_FEATURES --color ${colors}

         EXTRA_LIB=" --extern $CRATE_NAME=target/deps/lib$CRATE_NAME-${metadata}.rlib"
         if [ -e target/deps/lib$CRATE_NAME-${metadata}.so ]; then
            EXTRA_LIB="$EXTRA_LIB --extern $CRATE_NAME=target/deps/lib$CRATE_NAME-${metadata}.so"
         fi

      fi

      echo "$EXTRA_LINK_SEARCH" | while read i; do
         if [ ! -z "$i" ]; then
           for lib in $i; do
             echo "-L $lib" >> target/link
             L=$(echo $lib | sed -e "s#$(pwd)/target/build#$out#")
             echo "-L $L" >> target/link.final
           done
         fi
      done
      echo "$EXTRA_LINK" | while read i; do
         if [ ! -z "$i" ]; then
           for lib in $i; do
             echo "-l $lib" >> target/link
             echo "-l $lib" >> target/link.final
           done
         fi
      done

      if [ -e target/link ]; then
         sort -u target/link.final > target/link.final.sorted
         mv target/link.final.sorted target/link.final
         sort -u target/link > target/link.sorted
         mv target/link.sorted target/link

         tr '\n' ' ' < target/link > target/link_
         LINK=$(cat target/link_)
       fi

      mkdir -p target/bin
      echo "${crateBin}" | sed -n 1'p' | tr ',' '\n' | while read BIN; do
         if [ ! -z "$BIN" ]; then
           echo "$boldgreen""Building $BIN$norm"
           if ${verboseBuild}; then
             echo "$boldgreen""Running$norm rustc --crate-name $BIN --crate-type bin ${rustcOpts} ${crateFeatures} --out-dir target/bin --emit=dep-info,link -L dependency=target/deps $LINK ${deps}$EXTRA_LIB --cap-lints allow $BUILD_OUT_DIR $EXTRA_BUILD $EXTRA_FEATURES"
           fi
           rustc --crate-name $BIN --crate-type bin ${rustcOpts} ${crateFeatures} \
             --out-dir target/bin --emit=dep-info,link -L dependency=target/deps \
             $LINK ${deps}$EXTRA_LIB --cap-lints allow \
             $BUILD_OUT_DIR $EXTRA_BUILD $EXTRA_FEATURES --color ${colors}
         fi
      done
      if [[ (-z "${crateBin}") && (-e src/main.rs) ]]; then
         echo "$boldgreen""Building src/main.rs (${crateName})$norm"
         if ${verboseBuild}; then
           echo "$boldgreen""Running$norm rustc --crate-name $CRATE_NAME src/main.rs --crate-type bin ${rustcOpts} ${crateFeatures} --out-dir target/bin --emit=dep-info,link -L dependency=target/deps $LINK ${deps}$EXTRA_LIB --cap-lints allow $BUILD_OUT_DIR $EXTRA_BUILD $EXTRA_FEATURES"
         fi
         rustc --crate-name $CRATE_NAME src/main.rs --crate-type bin ${rustcOpts} \
           ${crateFeatures} --out-dir target/bin --emit=dep-info,link \
           -L dependency=target/deps $LINK ${deps}$EXTRA_LIB --cap-lints allow \
           $BUILD_OUT_DIR $EXTRA_BUILD $EXTRA_FEATURES --color ${colors}
      fi
      # Remove object files to avoid "wrong ELF type"
      rm -f $(find target -name "*.o")
    '' + finalBins;

    installCrate = crateName: ''
      mkdir -p $out
      if [ -s target/env ]; then
        cp target/env $out/env
      fi
      if [ -s target/link.final ]; then
        cp target/link.final $out/link
      fi
      cp target/deps/* $out # */
      if [ "$(ls -A target/build)" ]; then # */
        cp -r target/build/* $out # */
      fi
      if [ "$(ls -A target/bin)" ]; then # */
        mkdir -p $out/bin
        cp -P target/bin/* $out/bin # */
      fi
    '';
in

crate: stdenv.mkDerivation rec {

    inherit (crate) crateName;

    src = if lib.hasAttr "src" crate then
        crate.src
      else
        pkgs.fetchCrate { inherit (crate) crateName version sha256; };
    rust = pkgs.rustc;
    release = if crate ? release then crate.release else false;
    name = "rust_${crate.crateName}-${crate.version}";
    buildInputs = [ rust pkgs.ncurses ] ++ (lib.attrByPath ["buildInputs"] [] crate);
    dependencies =
      builtins.map
        (dep: dep.overrideAttrs (attrs: { rust = rust; }))
        (lib.attrByPath ["dependencies"] [] crate);

    buildDependencies =
      builtins.map
        (dep: dep.overrideAttrs (attrs: { rust = rust; }))
        (lib.attrByPath ["buildDependencies"] [] crate);

    completeDeps = builtins.foldl' (comp: dep: if lib.lists.any (x: x == comp) dep.completeDeps then comp ++ dep.complete else comp) dependencies dependencies;
    completeBuildDeps = builtins.foldl' (comp: dep: if lib.lists.any (x: x == comp) dep.completeBuildDeps then comp ++ dep.complete else comp) buildDependencies buildDependencies;

    crateFeatures = if crate ? features then
       lib.concatMapStringsSep " " (f: "--cfg feature=\\\"${f}\\\"") crate.features
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
    crateType =
      if lib.attrByPath ["procMacro"] false crate then "proc-macro" else
      if lib.attrByPath ["plugin"] false crate then "dylib" else "lib";
    verboseBuild = if lib.attrByPath [ "verbose" ] false crate then "true" else "false";
    colors = lib.attrByPath [ "colors" ] "always" crate;
    buildPhase = buildCrate {
      inherit crateName dependencies buildDependencies completeDeps completeBuildDeps
              crateFeatures libName build release libPath crateType crateVersion
              metadata crateBin finalBins verboseBuild colors;
    };
    installPhase = installCrate crateName;
}
