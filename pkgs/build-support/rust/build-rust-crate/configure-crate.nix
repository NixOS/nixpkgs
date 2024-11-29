{ lib, stdenv, echo_colored, noisily, mkRustcDepArgs, mkRustcFeatureArgs }:
{
  build
, buildDependencies
, codegenUnits
, colors
, completeBuildDeps
, completeDeps
, crateAuthors
, crateDescription
, crateFeatures
, crateHomepage
, crateLicense
, crateLicenseFile
, crateLinks
, crateName
, crateType
, crateReadme
, crateRenames
, crateRepository
, crateRustVersion
, crateVersion
, extraLinkFlags
, extraRustcOptsForBuildRs
, libName
, libPath
, release
, verbose
, workspace_member }:
let version_ = lib.splitString "-" crateVersion;
    versionPre = lib.optionalString (lib.tail version_ != []) (lib.elemAt version_ 1);
    version = lib.splitVersion (lib.head version_);
    rustcOpts = lib.foldl' (opts: opt: opts + " " + opt)
        (if release then "-C opt-level=3" else "-C debuginfo=2")
        (["-C codegen-units=${toString codegenUnits}"] ++ extraRustcOptsForBuildRs);
    buildDeps = mkRustcDepArgs buildDependencies crateRenames;
    authors = lib.concatStringsSep ":" crateAuthors;
    optLevel = if release then 3 else 0;
    completeDepsDir = lib.concatStringsSep " " completeDeps;
    completeBuildDepsDir = lib.concatStringsSep " " completeBuildDeps;
    envFeatures = lib.concatStringsSep " " (
      map (f: lib.replaceStrings ["-"] ["_"] (lib.toUpper f)) crateFeatures
    );
in ''
  ${echo_colored colors}
  ${noisily colors verbose}
  source ${./lib.sh}

  ${lib.optionalString (workspace_member != null) ''
  noisily cd "${workspace_member}"
''}
  ${lib.optionalString (workspace_member == null) ''
  echo_colored "Searching for matching Cargo.toml (${crateName})"
  local cargo_toml_dir=$(matching_cargo_toml_dir "${crateName}")
  if [ -z "$cargo_toml_dir" ]; then
    echo_error "ERROR configuring ${crateName}: No matching Cargo.toml in $(pwd) found." >&2
    exit 23
  fi
  noisily cd "$cargo_toml_dir"
''}

  runHook preConfigure

  symlink_dependency() {
    # $1 is the nix-store path of a dependency
    # $2 is the target path
    i=$1
    ln -s -f $i/lib/*.rlib $2 #*/
    ln -s -f $i/lib/*.so $i/lib/*.dylib $2 #*/
    if [ -e $i/env ]; then
        source $i/env
    fi
  }

  # The following steps set up the dependencies of the crate. Two
  # kinds of dependencies are distinguished: build dependencies
  # (used by the build script) and crate dependencies. For each
  # dependency we have to:
  #
  # - Make its Rust library available to rustc. This is done by
  #   symlinking all library dependencies into a directory that
  #   can be provided to rustc.
  # - Accumulate linking flags. These flags are largely used for
  #   linking native libraries.
  #
  # The crate link flags are added to the `link` and `link.final`
  # files. The `link` file is used for linkage in the current
  # crate. The `link.final` file will be copied to the output and can
  # be used by downstream crates to get the linker flags of this
  # crate.

  mkdir -p target/{deps,lib,build,buildDeps}
  chmod uga+w target -R
  echo ${extraLinkFlags} > target/link
  echo ${extraLinkFlags} > target/link.final

  # Prepare crate dependencies
  for i in ${completeDepsDir}; do
    symlink_dependency $i target/deps
    if [ -e "$i/lib/link" ]; then
      cat $i/lib/link >> target/link
      cat $i/lib/link >> target/link.final
    fi
  done

  # Prepare crate build dependencies that are used for the build script.
  for i in ${completeBuildDepsDir}; do
    symlink_dependency $i target/buildDeps
    if [ -e "$i/lib/link" ]; then
      cat $i/lib/link >> target/link.build
    fi
  done

  # Remove duplicate linker flags from the build dependencies.
  if [[ -e target/link.build ]]; then
    sort -uo target/link.build target/link.build
  fi

  # Remove duplicate linker flags from the dependencies.
  sort -uo target/link target/link
  tr '\n' ' ' < target/link > target/link_

  # Remove duplicate linker flags from the that are written
  # to the derivation's output.
  sort -uo target/link.final target/link.final

  EXTRA_BUILD=""
  BUILD_OUT_DIR=""

  # Set up Cargo Environment variables: https://doc.rust-lang.org/cargo/reference/environment-variables.html
  export CARGO_PKG_NAME=${crateName}
  export CARGO_PKG_VERSION=${crateVersion}
  export CARGO_PKG_AUTHORS="${authors}"
  export CARGO_PKG_DESCRIPTION="${crateDescription}"

  export CARGO_CFG_TARGET_ARCH=${stdenv.hostPlatform.rust.platform.arch}
  export CARGO_CFG_TARGET_OS=${stdenv.hostPlatform.rust.platform.os}
  export CARGO_CFG_TARGET_FAMILY="unix"
  export CARGO_CFG_UNIX=1
  export CARGO_CFG_TARGET_ENV="gnu"
  export CARGO_CFG_TARGET_ENDIAN=${if stdenv.hostPlatform.parsed.cpu.significantByte.name == "littleEndian" then "little" else "big"}
  export CARGO_CFG_TARGET_POINTER_WIDTH=${with stdenv.hostPlatform; toString (if isILP32 then 32 else parsed.cpu.bits)}
  export CARGO_CFG_TARGET_VENDOR=${stdenv.hostPlatform.parsed.vendor.name}

  export CARGO_MANIFEST_DIR=$(pwd)
  export CARGO_MANIFEST_LINKS=${crateLinks}
  export DEBUG="${toString (!release)}"
  export OPT_LEVEL="${toString optLevel}"
  export TARGET="${stdenv.hostPlatform.rust.rustcTargetSpec}"
  export HOST="${stdenv.buildPlatform.rust.rustcTargetSpec}"
  export PROFILE=${if release then "release" else "debug"}
  export OUT_DIR=$(pwd)/target/build/${crateName}.out
  export CARGO_PKG_VERSION_MAJOR=${lib.elemAt version 0}
  export CARGO_PKG_VERSION_MINOR=${lib.elemAt version 1}
  export CARGO_PKG_VERSION_PATCH=${lib.elemAt version 2}
  export CARGO_PKG_VERSION_PRE="${versionPre}"
  export CARGO_PKG_HOMEPAGE="${crateHomepage}"
  export CARGO_PKG_LICENSE="${crateLicense}"
  export CARGO_PKG_LICENSE_FILE="${crateLicenseFile}"
  export CARGO_PKG_README="${crateReadme}"
  export CARGO_PKG_REPOSITORY="${crateRepository}"
  export CARGO_PKG_RUST_VERSION="${crateRustVersion}"
  export NUM_JOBS=$NIX_BUILD_CORES
  export RUSTC="rustc"
  export RUSTDOC="rustdoc"

  BUILD=""
  if [[ ! -z "${build}" ]] ; then
     BUILD=${build}
  elif [[ -e "build.rs" ]]; then
     BUILD="build.rs"
  fi

  # Compile and run the build script, when available.
  if [[ ! -z "$BUILD" ]] ; then
     echo_build_heading "$BUILD" ${libName}
     mkdir -p target/build/${crateName}
     EXTRA_BUILD_FLAGS=""
     if [ -e target/link.build ]; then
       EXTRA_BUILD_FLAGS="$EXTRA_BUILD_FLAGS $(tr '\n' ' ' < target/link.build)"
     fi
     noisily rustc --crate-name build_script_build $BUILD --crate-type bin ${rustcOpts} \
       ${mkRustcFeatureArgs crateFeatures} --out-dir target/build/${crateName} --emit=dep-info,link \
       -L dependency=target/buildDeps ${buildDeps} --cap-lints allow $EXTRA_BUILD_FLAGS --color ${colors}

     mkdir -p target/build/${crateName}.out
     export RUST_BACKTRACE=1
     BUILD_OUT_DIR="-L $OUT_DIR"
     mkdir -p $OUT_DIR

     (
       # Features should be set as environment variable for build scripts:
       # https://doc.rust-lang.org/cargo/reference/environment-variables.html#environment-variables-cargo-sets-for-build-scripts
       for feature in ${envFeatures}; do
         export CARGO_FEATURE_$feature=1
       done

       target/build/${crateName}/build_script_build | tee target/build/${crateName}.opt
     )

     set +e
     # We want to support the new prefix invocation syntax which uses two colons
     # See https://doc.rust-lang.org/cargo/reference/build-scripts.html#outputs-of-the-build-script

     EXTRA_BUILD=$(sed -n "s/^cargo::\{0,1\}rustc-flags=\(.*\)/\1/p" target/build/${crateName}.opt | tr '\n' ' ' | sort -u)
     EXTRA_FEATURES=$(sed -n "s/^cargo::\{0,1\}rustc-cfg=\(.*\)/--cfg \1/p" target/build/${crateName}.opt | tr '\n' ' ')
     EXTRA_LINK_ARGS=$(sed -n "s/^cargo::\{0,1\}rustc-link-arg=\(.*\)/-C link-arg=\1/p" target/build/${crateName}.opt | tr '\n' ' ')
     EXTRA_LINK_ARGS_BINS=$(sed -n "s/^cargo::\{0,1\}rustc-link-arg-bins=\(.*\)/-C link-arg=\1/p" target/build/${crateName}.opt | tr '\n' ' ')
     EXTRA_LINK_ARGS_LIB=$(sed -n "s/^cargo::\{0,1\}rustc-link-arg-lib=\(.*\)/-C link-arg=\1/p" target/build/${crateName}.opt | tr '\n' ' ')
     EXTRA_LINK_LIBS=$(sed -n "s/^cargo::\{0,1\}rustc-link-lib=\(.*\)/\1/p" target/build/${crateName}.opt | tr '\n' ' ')
     EXTRA_LINK_SEARCH=$(sed -n "s/^cargo::\{0,1\}rustc-link-search=\(.*\)/\1/p" target/build/${crateName}.opt | tr '\n' ' ' | sort -u)

     ${lib.optionalString (lib.elem "cdylib" crateType) ''
     CRATE_TYPE_IS_CDYLIB="true"
     EXTRA_CDYLIB_LINK_ARGS=$(sed -n "s/^cargo::\{0,1\}rustc-cdylib-link-arg=\(.*\)/-C link-arg=\1/p" target/build/${crateName}.opt | tr '\n' ' ')
''}

     # We want to read part of every line that has cargo:rustc-env= prefix and
     # export it as environment variables. This turns out tricky if the lines
     # have spaces: we can't wrap the command in double quotes as that captures
     # all the lines in single output. We can't use while read loop because
     # exporting from inside of it doesn't make it to the outside scope. We
     # can't use xargs as export is a built-in and does not work from it. As a
     # last resort then, we change the IFS so that the for loop does not split
     # on spaces and reset it after we are done. See ticket #199298.
     #
     _OLDIFS="$IFS"
     IFS=$'\n'
     for env in $(sed -n "s/^cargo::\{0,1\}rustc-env=\(.*\)/\1/p" target/build/${crateName}.opt); do
       export "$env"
     done
     IFS="$_OLDIFS"

     CRATENAME=$(echo ${crateName} | sed -e "s/\(.*\)-sys$/\U\1/" -e "s/-/_/g")
     grep -P "^cargo:(?!:?(rustc-|warning=|rerun-if-changed=|rerun-if-env-changed))" target/build/${crateName}.opt \
       | awk -F= "/^cargo::metadata=/ {  gsub(/-/, \"_\", \$2); print \"export \" toupper(\"DEP_$(echo $CRATENAME)_\" \$2) \"=\" \"\\\"\"\$3\"\\\"\"; next }
                  /^cargo:/ { sub(/^cargo::?/, \"\", \$1); gsub(/-/, \"_\", \$1); print \"export \" toupper(\"DEP_$(echo $CRATENAME)_\" \$1) \"=\" \"\\\"\"\$2\"\\\"\"; next }" > target/env
     set -e
  fi
  runHook postConfigure
''
