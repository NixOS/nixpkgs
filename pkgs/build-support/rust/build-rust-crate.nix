# Code for buildRustCrate, a Nix function that builds Rust code, just
# like Cargo, but using Nix instead.
#
# This can be useful for deploying packages with NixOps, and to share
# binary dependencies between projects.

{ lib, stdenv, defaultCrateOverrides, fetchCrate, ncurses, rustc  }:

let makeDeps = dependencies:
      (lib.concatMapStringsSep " " (dep:
        let extern = lib.strings.replaceStrings ["-"] ["_"] dep.libName; in
        (if dep.crateType == "lib" then
           " --extern ${extern}=${dep.out}/lib/lib${extern}-${dep.metadata}.rlib"
         else
           " --extern ${extern}=${dep.out}/lib/lib${extern}-${dep.metadata}${stdenv.hostPlatform.extensions.sharedLibrary}")
      ) dependencies);

    # This doesn't appear to be officially documented anywhere yet.
    # See https://github.com/rust-lang-nursery/rust-forge/issues/101.
    target_os = if stdenv.hostPlatform.isDarwin
      then "macos"
      else stdenv.hostPlatform.parsed.kernel.name;

    echo_build_heading = colors: ''
      echo_build_heading() {
       start=""
       end=""
       if [[ "${colors}" == "always" ]]; then
         start="$(printf '\033[0;1;32m')" #set bold, and set green.
         end="$(printf '\033[0m')" #returns to "normal"
       fi
       if (( $# == 1 )); then
         echo "$start""Building $1""$end"
       else
         echo "$start""Building $1 ($2)""$end"
       fi
      }
    '';
    noisily = colors: verbose: ''
      noisily() {
        start=""
        end=""
        if [[ "${colors}" == "always" ]]; then
          start="$(printf '\033[0;1;32m')" #set bold, and set green.
          end="$(printf '\033[0m')" #returns to "normal"
        fi
	${lib.optionalString verbose ''
            echo -n "$start"Running "$end"
            echo $@
	''}
	$@
      }
    '';

    configureCrate =
      { crateName, crateVersion, crateAuthors, build, libName, crateFeatures, colors, libPath, release, buildDependencies, completeDeps, completeBuildDeps, verbose, workspace_member, extraLinkFlags }:
      let version_ = lib.splitString "-" crateVersion;
          versionPre = if lib.tail version_ == [] then "" else builtins.elemAt version_ 1;
          version = lib.splitString "." (lib.head version_);
          rustcOpts = (if release then "-C opt-level=3" else "-C debuginfo=2");
          buildDeps = makeDeps buildDependencies;
          authors = lib.concatStringsSep ":" crateAuthors;
          optLevel = if release then 3 else 0;
          completeDepsDir = lib.concatStringsSep " " completeDeps;
          completeBuildDepsDir = lib.concatStringsSep " " completeBuildDeps;
      in ''
      cd ${workspace_member}
      runHook preConfigure
      ${echo_build_heading colors}
      ${noisily colors verbose}
      symlink_dependency() {
        # $1 is the nix-store path of a dependency
        # $2 is the target path
        i=$1
        ln -s -f $i/lib/*.rlib $2 #*/
        ln -s -f $i/lib/*.so $i/lib/*.dylib $2 #*/
        if [ -e "$i/lib/link" ]; then
            cat $i/lib/link >> target/link
            cat $i/lib/link >> target/link.final
        fi
        if [ -e $i/env ]; then
            source $i/env
        fi
      }

      mkdir -p target/{deps,lib,build,buildDeps}
      chmod uga+w target -R
      echo ${extraLinkFlags} > target/link
      echo ${extraLinkFlags} > target/link.final
      for i in ${completeDepsDir}; do
        symlink_dependency $i target/deps
      done
      for i in ${completeBuildDepsDir}; do
         symlink_dependency $i target/buildDeps
      done
      if [[ -e target/link ]]; then
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
      export CARGO_PKG_AUTHORS="${authors}"

      export CARGO_CFG_TARGET_ARCH=${stdenv.hostPlatform.parsed.cpu.name}
      export CARGO_CFG_TARGET_OS=${target_os}
      export CARGO_CFG_TARGET_FAMILY="unix"
      export CARGO_CFG_UNIX=1
      export CARGO_CFG_TARGET_ENV="gnu"
      export CARGO_CFG_TARGET_ENDIAN=${if stdenv.hostPlatform.parsed.cpu.significantByte.name == "littleEndian" then "little" else "big"}
      export CARGO_CFG_TARGET_POINTER_WIDTH=${toString stdenv.hostPlatform.parsed.cpu.bits}
      export CARGO_CFG_TARGET_VENDOR=${stdenv.hostPlatform.parsed.vendor.name}

      export CARGO_MANIFEST_DIR="."
      export DEBUG="${toString (!release)}"
      export OPT_LEVEL="${toString optLevel}"
      export TARGET="${stdenv.hostPlatform.config}"
      export HOST="${stdenv.hostPlatform.config}"
      export PROFILE=${if release then "release" else "debug"}
      export OUT_DIR=$(pwd)/target/build/${crateName}.out
      export CARGO_PKG_VERSION_MAJOR=${builtins.elemAt version 0}
      export CARGO_PKG_VERSION_MINOR=${builtins.elemAt version 1}
      export CARGO_PKG_VERSION_PATCH=${builtins.elemAt version 2}
      if [[ -n "${versionPre}" ]]; then
        export CARGO_PKG_VERSION_PRE="${versionPre}"
      fi

      BUILD=""
      if [[ ! -z "${build}" ]] ; then
         BUILD=${build}
      elif [[ -e "build.rs" ]]; then
         BUILD="build.rs"
      fi
      if [[ ! -z "$BUILD" ]] ; then
         echo_build_heading "$BUILD" ${libName}
         mkdir -p target/build/${crateName}
         EXTRA_BUILD_FLAGS=""
         if [ -e target/link_ ]; then
           EXTRA_BUILD_FLAGS=$(cat target/link_)
         fi
         if [ -e target/link.build ]; then
           EXTRA_BUILD_FLAGS="$EXTRA_BUILD_FLAGS $(cat target/link.build)"
         fi
         noisily rustc --crate-name build_script_build $BUILD --crate-type bin ${rustcOpts} \
           ${crateFeatures} --out-dir target/build/${crateName} --emit=dep-info,link \
           -L dependency=target/buildDeps ${buildDeps} --cap-lints allow $EXTRA_BUILD_FLAGS --color ${colors}

         mkdir -p target/build/${crateName}.out
         export RUST_BACKTRACE=1
         BUILD_OUT_DIR="-L $OUT_DIR"
         mkdir -p $OUT_DIR
         target/build/${crateName}/build_script_build > target/build/${crateName}.opt
         set +e
         EXTRA_BUILD=$(sed -n "s/^cargo:rustc-flags=\(.*\)/\1/p" target/build/${crateName}.opt | tr '\n' ' ' | sort -u)
         EXTRA_FEATURES=$(sed -n "s/^cargo:rustc-cfg=\(.*\)/--cfg \1/p" target/build/${crateName}.opt | tr '\n' ' ')
         EXTRA_LINK=$(sed -n "s/^cargo:rustc-link-lib=\(.*\)/\1/p" target/build/${crateName}.opt | tr '\n' ' ' | sort -u)
         EXTRA_LINK_SEARCH=$(sed -n "s/^cargo:rustc-link-search=\(.*\)/\1/p" target/build/${crateName}.opt | tr '\n' ' ' | sort -u)

         for env in $(sed -n "s/^cargo:rustc-env=\(.*\)/\1/p" target/build/${crateName}.opt); do
           export $env
         done

         CRATENAME=$(echo ${crateName} | sed -e "s/\(.*\)-sys$/\U\1/")
         grep -P "^cargo:(?!(rustc-|warning=|rerun-if-changed=|rerun-if-env-changed))" target/build/${crateName}.opt \
           | sed -e "s/cargo:\([^=]*\)=\(.*\)/export DEP_$(echo $CRATENAME)_\U\1\E=\2/" > target/env

         set -e
         if [[ -n "$(ls target/build/${crateName}.out)" ]]; then

            if [[ -e "${libPath}" ]]; then
               cp -r target/build/${crateName}.out/* $(dirname ${libPath}) #*/
            else
               cp -r target/build/${crateName}.out/* src #*/
            fi
         fi
      fi
      runHook postConfigure
    '';

    buildCrate = { crateName,
                   dependencies,
                   crateFeatures, libName, release, libPath,
                   crateType, metadata, crateBin, finalBins,
                   extraRustcOpts, verbose, colors }:

      let deps = makeDeps dependencies;
          rustcOpts =
            lib.lists.foldl' (opts: opt: opts + " " + opt)
              (if release then "-C opt-level=3" else "-C debuginfo=2")
              (["-C codegen-units=1"] ++ extraRustcOpts);
          rustcMeta = "-C metadata=${metadata} -C extra-filename=-${metadata}";
      in ''
      runHook preBuild
      norm=""
      bold=""
      green=""
      boldgreen=""
      if [[ "${colors}" == "always" ]]; then
        norm="$(printf '\033[0m')" #returns to "normal"
        bold="$(printf '\033[0;1m')" #set bold
        green="$(printf '\033[0;32m')" #set green
        boldgreen="$(printf '\033[0;1;32m')" #set bold, and set green.
      fi
      ${echo_build_heading colors}
      ${noisily colors verbose}

      build_lib() {
         lib_src=$1
         echo_build_heading $lib_src ${libName}

         noisily rustc --crate-name $CRATE_NAME $lib_src --crate-type ${crateType} \
           ${rustcOpts} ${rustcMeta} ${crateFeatures} --out-dir target/lib \
           --emit=dep-info,link -L dependency=target/deps ${deps} --cap-lints allow \
           $BUILD_OUT_DIR $EXTRA_BUILD $EXTRA_FEATURES --color ${colors}

         EXTRA_LIB=" --extern $CRATE_NAME=target/lib/lib$CRATE_NAME-${metadata}.rlib"
         if [ -e target/deps/lib$CRATE_NAME-${metadata}${stdenv.hostPlatform.extensions.sharedLibrary} ]; then
            EXTRA_LIB="$EXTRA_LIB --extern $CRATE_NAME=target/lib/lib$CRATE_NAME-${metadata}${stdenv.hostPlatform.extensions.sharedLibrary}"
         fi
      }

      build_bin() {
        crate_name=$1
        crate_name_=$(echo $crate_name | sed -e "s/-/_/g")
        main_file=""
        if [[ ! -z $2 ]]; then
          main_file=$2
        fi
        echo_build_heading $@
        noisily rustc --crate-name $crate_name_ $main_file --crate-type bin ${rustcOpts}\
          ${crateFeatures} --out-dir target/bin --emit=dep-info,link -L dependency=target/deps \
          $LINK ${deps}$EXTRA_LIB --cap-lints allow \
          $BUILD_OUT_DIR $EXTRA_BUILD $EXTRA_FEATURES --color ${colors}
        if [ "$crate_name_" != "$crate_name" ]; then
          mv target/bin/$crate_name_ target/bin/$crate_name
        fi
      }


      EXTRA_LIB=""
      CRATE_NAME=$(echo ${libName} | sed -e "s/-/_/g")

      if [[ -e target/link_ ]]; then
        EXTRA_BUILD="$(cat target/link_) $EXTRA_BUILD"
      fi

      if [[ -e "${libPath}" ]]; then
         build_lib ${libPath}
      elif [[ -e src/lib.rs ]]; then
         build_lib src/lib.rs
      elif [[ -e src/${libName}.rs ]]; then
         build_lib src/${libName}.rs
      fi

      echo "$EXTRA_LINK_SEARCH" | while read i; do
         if [[ ! -z "$i" ]]; then
           for lib in $i; do
             echo "-L $lib" >> target/link
             L=$(echo $lib | sed -e "s#$(pwd)/target/build#$out/lib#")
             echo "-L $L" >> target/link.final
           done
         fi
      done
      echo "$EXTRA_LINK" | while read i; do
         if [[ ! -z "$i" ]]; then
           for lib in $i; do
             echo "-l $lib" >> target/link
             echo "-l $lib" >> target/link.final
           done
         fi
      done

      if [[ -e target/link ]]; then
         sort -u target/link.final > target/link.final.sorted
         mv target/link.final.sorted target/link.final
         sort -u target/link > target/link.sorted
         mv target/link.sorted target/link

         tr '\n' ' ' < target/link > target/link_
         LINK=$(cat target/link_)
       fi

      mkdir -p target/bin
      echo "${crateBin}" | sed -n 1'p' | tr ',' '\n' | while read BIN; do
         if [[ ! -z "$BIN" ]]; then
           build_bin $BIN
         fi
      done
      ${lib.optionalString (crateBin == "") ''
        if [[ -e src/main.rs ]]; then
          build_bin ${crateName} src/main.rs
        fi
        for i in src/bin/*.rs; do #*/
          build_bin "$(basename $i .rs)" "$i"
        done
      ''}
      # Remove object files to avoid "wrong ELF type"
      find target -type f -name "*.o" -print0 | xargs -0 rm -f
    '' + finalBins + ''
      runHook postBuild
    '';

    installCrate = crateName: metadata: ''
      runHook preInstall
      mkdir -p $out
      if [[ -s target/env ]]; then
        cp target/env $out/env
      fi
      if [[ -s target/link.final ]]; then
        mkdir -p $out/lib
        cp target/link.final $out/lib/link
      fi
      if [[ "$(ls -A target/lib)" ]]; then
        mkdir -p $out/lib
        cp target/lib/* $out/lib #*/
        for lib in $out/lib/*.so $out/lib/*.dylib; do #*/
          ln -s $lib $(echo $lib | sed -e "s/-${metadata}//")
        done
      fi
      if [[ "$(ls -A target/build)" ]]; then # */
        mkdir -p $out/lib
        cp -r target/build/* $out/lib # */
      fi
      if [[ "$(ls -A target/bin)" ]]; then
        mkdir -p $out/bin
        cp -P target/bin/* $out/bin # */
      fi
      runHook postInstall
    '';
in

crate_: lib.makeOverridable ({ rust, release, verbose, features, buildInputs, crateOverrides,
  dependencies, buildDependencies,
  extraRustcOpts,
  preUnpack, postUnpack, prePatch, patches, postPatch,
  preConfigure, postConfigure, preBuild, postBuild, preInstall, postInstall }:

let crate = crate_ // (lib.attrByPath [ crate_.crateName ] (attr: {}) crateOverrides crate_);
    dependencies_ = dependencies;
    buildDependencies_ = buildDependencies;
    processedAttrs = [
      "src" "buildInputs" "crateBin" "crateLib" "libName" "libPath"
      "buildDependencies" "dependencies" "features"
      "crateName" "version" "build" "authors" "colors"
    ];
    extraDerivationAttrs = lib.filterAttrs (n: v: ! lib.elem n processedAttrs) crate;
    buildInputs_ = buildInputs;
in
stdenv.mkDerivation (rec {

    inherit (crate) crateName;
    inherit preUnpack postUnpack prePatch patches postPatch preConfigure postConfigure preBuild postBuild preInstall postInstall;

    src = if lib.hasAttr "src" crate then
        crate.src
      else
        fetchCrate { inherit (crate) crateName version sha256; };
    name = "rust_${crate.crateName}-${crate.version}";
    buildInputs = [ rust ncurses ] ++ (crate.buildInputs or []) ++ buildInputs_;
    dependencies =
      builtins.map
        (dep: dep.override { rust = rust; release = release; verbose = verbose; crateOverrides = crateOverrides; })
        dependencies_;

    buildDependencies =
      builtins.map
        (dep: dep.override { rust = rust; release = release; verbose = verbose; crateOverrides = crateOverrides; })
        buildDependencies_;

    completeDeps = lib.lists.unique (dependencies ++ lib.lists.concatMap (dep: dep.completeDeps) dependencies);
    completeBuildDeps = lib.lists.unique (
      buildDependencies
      ++ lib.lists.concatMap (dep: dep.completeBuildDeps ++ dep.completeDeps) buildDependencies
    );

    crateFeatures = if crate ? features then
        lib.concatMapStringsSep " " (f: "--cfg feature=\\\"${f}\\\"") (crate.features ++ features) #"
      else "";

    libName = if crate ? libName then crate.libName else crate.crateName;
    libPath = if crate ? libPath then crate.libPath else "";

    depsMetadata = builtins.foldl' (str: dep: str + dep.metadata) "" (dependencies ++ buildDependencies);
    metadata = builtins.substring 0 10 (builtins.hashString "sha256" (crateName + "-" + crateVersion + "___" + toString crateFeatures + "___" + depsMetadata ));

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

    build = crate.build or "";
    workspace_member = crate.workspace_member or ".";
    crateVersion = crate.version;
    crateAuthors = if crate ? authors && lib.isList crate.authors then crate.authors else [];
    crateType =
      if lib.attrByPath ["procMacro"] false crate then "proc-macro" else
      if lib.attrByPath ["plugin"] false crate then "dylib" else
      (crate.type or "lib");
    colors = lib.attrByPath [ "colors" ] "always" crate;
    extraLinkFlags = builtins.concatStringsSep " " (crate.extraLinkFlags or []);
    configurePhase = configureCrate {
      inherit crateName buildDependencies completeDeps completeBuildDeps
              crateFeatures libName build workspace_member release libPath crateVersion
              extraLinkFlags
              crateAuthors verbose colors;
    };
    extraRustcOpts = if crate ? extraRustcOpts then crate.extraRustcOpts else [];
    buildPhase = buildCrate {
      inherit crateName dependencies
              crateFeatures libName release libPath crateType
              metadata crateBin finalBins verbose colors
              extraRustcOpts;
    };
    installPhase = installCrate crateName metadata;

} // extraDerivationAttrs
)) {
  rust = rustc;
  release = crate_.release or true;
  verbose = crate_.verbose or true;
  extraRustcOpts = [];
  features = [];
  buildInputs = [];
  crateOverrides = defaultCrateOverrides;
  preUnpack = crate_.preUnpack or "";
  postUnpack = crate_.postUnpack or "";
  prePatch = crate_.prePatch or "";
  patches = crate_.patches or [];
  postPatch = crate_.postPatch or "";
  preConfigure = crate_.preConfigure or "";
  postConfigure = crate_.postConfigure or "";
  preBuild = crate_.preBuild or "";
  postBuild = crate_.postBuild or "";
  preInstall = crate_.preInstall or "";
  postInstall = crate_.postInstall or "";
  dependencies = crate_.dependencies or [];
  buildDependencies = crate_.buildDependencies or [];
}
