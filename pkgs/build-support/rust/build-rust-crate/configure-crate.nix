{ lib, stdenv, echo_build_heading, noisily, makeDeps }:
{ build
, buildDependencies
, colors
, completeBuildDeps
, completeDeps
, crateAuthors
, crateDescription
, crateHomepage
, crateFeatures
, crateName
, crateVersion
, extraLinkFlags
, extraRustcOpts
, libName
, libPath
, release
, target_os
, verbose
, workspace_member }:
let version_ = lib.splitString "-" crateVersion;
    versionPre = if lib.tail version_ == [] then "" else builtins.elemAt version_ 1;
    version = lib.splitString "." (lib.head version_);
    rustcOpts = lib.lists.foldl' (opts: opt: opts + " " + opt)
        (if release then "-C opt-level=3" else "-C debuginfo=2")
        (["-C codegen-units=$NIX_BUILD_CORES"] ++ extraRustcOpts);
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
  export CARGO_PKG_DESCRIPTION="${crateDescription}"

  export CARGO_CFG_TARGET_ARCH=${stdenv.hostPlatform.parsed.cpu.name}
  export CARGO_CFG_TARGET_OS=${target_os}
  export CARGO_CFG_TARGET_FAMILY="unix"
  export CARGO_CFG_UNIX=1
  export CARGO_CFG_TARGET_ENV="gnu"
  export CARGO_CFG_TARGET_ENDIAN=${if stdenv.hostPlatform.parsed.cpu.significantByte.name == "littleEndian" then "little" else "big"}
  export CARGO_CFG_TARGET_POINTER_WIDTH=${toString stdenv.hostPlatform.parsed.cpu.bits}
  export CARGO_CFG_TARGET_VENDOR=${stdenv.hostPlatform.parsed.vendor.name}

  export CARGO_MANIFEST_DIR=$(pwd)
  export DEBUG="${toString (!release)}"
  export OPT_LEVEL="${toString optLevel}"
  export TARGET="${stdenv.hostPlatform.config}"
  export HOST="${stdenv.hostPlatform.config}"
  export PROFILE=${if release then "release" else "debug"}
  export OUT_DIR=$(pwd)/target/build/${crateName}.out
  export CARGO_PKG_VERSION_MAJOR=${builtins.elemAt version 0}
  export CARGO_PKG_VERSION_MINOR=${builtins.elemAt version 1}
  export CARGO_PKG_VERSION_PATCH=${builtins.elemAt version 2}
  export CARGO_PKG_VERSION_PRE="${versionPre}"
  export CARGO_PKG_HOMEPAGE="${crateHomepage}"
  export NUM_JOBS=1
  export RUSTC="rustc"
  export RUSTDOC="rustdoc"

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
''

