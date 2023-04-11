{ lib
, stdenv
, mkRustcDepArgs
, mkRustcFeatureArgs
, needUnstableCLI
, rust
, buildRustCrateHelpers
}:
{ crateName
, dependencies
, crateFeatures
, crateRenames
, release
, libName
, libPath
, libHarness
, crateType
, metadata
, crateBin
, hasCrateBin
, extraRustcOpts
, verbose
, colors
, buildKinds
, buildTests
, codegenUnits
}:
let
  baseRustcOpts =
    [
      (if release then "-C opt-level=3" else "-C debuginfo=2")
      "-C codegen-units=${toString codegenUnits}"
      "--remap-path-prefix=$NIX_BUILD_TOP=/"
      (mkRustcDepArgs dependencies crateRenames)
      (mkRustcFeatureArgs crateFeatures)
    ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
      "--target"
      (rust.toRustTargetSpec stdenv.hostPlatform)
    ] ++ lib.optionals (needUnstableCLI dependencies) [
      "-Z"
      "unstable-options"
    ] ++ extraRustcOpts
    # since rustc 1.42 the "proc_macro" crate is part of the default crate prelude
    # https://github.com/rust-lang/cargo/commit/4d64eb99a4#diff-7f98585dbf9d30aa100c8318e2c77e79R1021-R1022
    ++ lib.optional (lib.elem "proc-macro" crateType) "--extern proc_macro"
  ;
  rustcMeta = "-C metadata=${metadata} -C extra-filename=-${metadata}";

  # build the final rustc arguments that can be different between different
  # crates
  libRustcOpts = lib.concatStringsSep " " (
    baseRustcOpts
    ++ [ rustcMeta ]
    ++ (map (x: "--crate-type ${x}") crateType)
  );

  binRustcOpts = lib.concatStringsSep " " (
    baseRustcOpts
  );

  inherit (buildRustCrateHelpers.kinds) kindToDir isTest isLib isExample isBench isBin;
  kindTypes = buildRustCrateHelpers.kinds.kind;

  buildTestsNew = buildTests || builtins.any isTest buildKinds;
  buildLib = builtins.any isLib buildKinds;
  buildBenches = builtins.any isBench buildKinds;
  buildBins = builtins.any isBin buildKinds;
  buildExamples = builtins.any isExample buildKinds;

  crateBinBins = hasCrateBin && builtins.any (t: if t ? kind then isBin t.kind else true) crateBin;
  crateBinTests = hasCrateBin && builtins.any (t: if t ? kind then isTest t.kind else false) crateBin;
  crateBinExamples = hasCrateBin && builtins.any (t: if t ? kind then isExample t.kind else false) crateBin;
  crateBinBenches = hasCrateBin && builtins.any (t: if t ? kind then isBench t.kind else false) crateBin;

  bashBoolToString = t: if t then "1" else "0";
in
''
  runHook preBuild

  # configure & source common build functions
  LIB_RUSTC_OPTS="${libRustcOpts}"
  BIN_RUSTC_OPTS="${binRustcOpts}"
  LIB_EXT="${stdenv.hostPlatform.extensions.sharedLibrary}"
  LIB_PATH="${libPath}"
  LIB_NAME="${libName}"
  LIB_HARNESS=${bashBoolToString libHarness}
  # Uses lowercase (kind types) for bash indirect substitution in auto discovery
  ${kindTypes.lib}_DIR="${kindToDir kindTypes.lib}"
  ${kindTypes.bin}_DIR="${kindToDir kindTypes.bin}"
  ${kindTypes.example}_DIR="${kindToDir kindTypes.example}"
  ${kindTypes.bench}_DIR="${kindToDir kindTypes.bench}"
  ${kindTypes.test}_DIR="${kindToDir kindTypes.test}"

  CRATE_NAME='${lib.replaceStrings ["-"] ["_"] libName}'

  setup_link_paths

  # If not specified it is src/lib.rs
  # https://doc.rust-lang.org/cargo/guide/project-layout.html
  if ! [ -e "$LIB_PATH" ]; then
    LIB_PATH=src/lib.rs
  fi

  if [ -e "$LIB_PATH" ]; then
     ${lib.optionalString buildLib ''build_lib_lib "$LIB_PATH"''}
     ${lib.optionalString buildTestsNew ''build_lib_test "$LIB_PATH" $LIB_HARNESS''}
     ${lib.optionalString buildBenches ''build_lib_bench "$LIB_PATH" $LIB_HARNESS''}
     true
  fi

  ${lib.optionalString (lib.length crateBin > 0) (lib.concatMapStringsSep "\n" (bin:
  let
  haveRequiredFeature =
    if bin ? requiredFeatures then
    # Check that all element in requiredFeatures are also present in crateFeatures
      lib.intersectLists bin.requiredFeatures crateFeatures == bin.requiredFeatures
    else
      true;

  # For back compatibility if not specified
  # 1. a normal binary
  # 2. Tests if `buildTests` is true
  # 3. Does not bench
  # 4. Uses harness (converted to bash 0/1)
  kind = if !bin ? kind then "bin" else
  lib.trivial.throwIfNot (isBench bin.kind || isTest bin.kind || isExample bin.kind || isBin bin.kind) ''
    Binary type must be of kind `bin`, `test`, `bench`, or `example`
  ''
    bin.kind;
  test = if bin ? test then bin.test else buildTests;
  bench = if bin ? bench then bin.bench else false;
  harness = bashBoolToString (if bin ? harness then bin.harness else true);

  # Require a name or path for all binaries
  binName = lib.trivial.throwIfNot (bin ? name) "A name is required for binary" bin.name;

  compileCommands = ''
    mkdir -p target/${kind}
    BIN_NAME="${binName}"
    BIN_PATH=""
    ${if !bin ? path then (
        if kind == "bin" then
          ''search_for_bin_path "$BIN_NAME"''
        else
          ''search_for_path "${kind}" $BIN_NAME"''
    ) else ''
      BIN_PATH="${bin.path}"
    ''}
    ${lib.optionalString ((buildBins && isBin kind) || (buildExamples && isExample kind)) ''
      build_bin_${kind} "$BIN_NAME" "$BIN_PATH" ${harness}
    ''}
    ${lib.optionalString (buildTestsNew && (test || isTest kind)) ''
      build_bin_test "$BIN_NAME" "$BIN_PATH" ${harness}
    ''}
    ${lib.optionalString (buildBenches && (bench || isBench kind)) ''
      build_bin_bench "$BIN_NAME" "$BIN_PATH" ${harness}
    ''}
  '';
  in
  if !haveRequiredFeature then ''
    echo Binary ${bin.name or crateName} not compiled due to not having all of the required features -- ${lib.escapeShellArg (builtins.toJSON bin.requiredFeatures)} -- enabled.
  '' else compileCommands) crateBin)}


  # Using cargo 2015 format of disabling auto-discovery when specifying a `crateBin` and there is a kind
  # specified. Because there is no duplicate detection currently:
  # https://doc.rust-lang.org/cargo/reference/cargo-targets.html?highlight=target%20auto-disc#target-auto-discovery
  # Also see the layout specs:
  # The names of the extra directories, see: https://doc.rust-lang.org/cargo/guide/project-layout.html
  ${lib.optionalString (buildBins && !crateBinBins) ''auto_build_bins "${crateName}" ${bashBoolToString buildTestsNew}''}
  ${lib.optionalString (buildExamples && !crateBinExamples) "auto_build_dir ${kindTypes.example} ${bashBoolToString buildTestsNew}"}
  ${lib.optionalString (buildTestsNew && !crateBinTests) "auto_build_dir ${kindTypes.test} ${bashBoolToString false}"}
  ${lib.optionalString (buildBenches && !crateBinBenches) "auto_build_dir ${kindTypes.bench} ${bashBoolToString false}"}

  # Remove object files to avoid "wrong ELF type"
  find target -type f -name "*.o" -print0 | xargs -0 rm -f
  runHook postBuild
''
