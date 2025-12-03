{
  lib,
  stdenv,
  mkRustcDepArgs,
  mkRustcFeatureArgs,
  needUnstableCLI,
  rustc,
}:

{
  crateName,
  dependencies,
  crateFeatures,
  crateRenames,
  libName,
  release,
  libPath,
  crateType,
  metadata,
  crateBin,
  hasCrateBin,
  extraRustcOpts,
  verbose,
  colors,
  buildTests,
  codegenUnits,
}:

let
  baseRustcOpts = [
    (if release then "-C opt-level=3" else "-C debuginfo=2")
    "-C codegen-units=${toString codegenUnits}"
    "--remap-path-prefix=$NIX_BUILD_TOP=/"
    (mkRustcDepArgs dependencies crateRenames)
    (mkRustcFeatureArgs crateFeatures)
  ]
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "--target"
    stdenv.hostPlatform.rust.rustcTargetSpec
  ]
  ++ lib.optionals (needUnstableCLI dependencies) [
    "-Z"
    "unstable-options"
  ]
  ++ extraRustcOpts
  # since rustc 1.42 the "proc_macro" crate is part of the default crate prelude
  # https://github.com/rust-lang/cargo/commit/4d64eb99a4#diff-7f98585dbf9d30aa100c8318e2c77e79R1021-R1022
  ++ lib.optional (lib.elem "proc-macro" crateType) "--extern proc_macro"
  ++
    lib.optional (stdenv.hostPlatform.linker == "lld" && rustc ? llvmPackages.lld) # Needed when building for targets that use lld. e.g. 'wasm32-unknown-unknown'
      "-C linker=${rustc.llvmPackages.lld}/bin/lld"
  ++ lib.optional (
    stdenv.hasCC && stdenv.hostPlatform.linker != "lld"
  ) "-C linker=${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc";
  rustcMeta = "-C metadata=${metadata} -C extra-filename=-${metadata}";

  # build the final rustc arguments that can be different between different
  # crates
  libRustcOpts = lib.concatStringsSep " " (
    baseRustcOpts ++ [ rustcMeta ] ++ (map (x: "--crate-type ${x}") crateType)
  );

  binRustcOpts = lib.concatStringsSep " " baseRustcOpts;

  build_bin = if buildTests then "build_bin_test" else "build_bin";
in
''
  runHook preBuild

  # configure & source common build functions
  LIB_RUSTC_OPTS="${libRustcOpts}"
  BIN_RUSTC_OPTS="${binRustcOpts}"
  LIB_EXT="${stdenv.hostPlatform.extensions.library}"
  LIB_PATH="${libPath}"
  LIB_NAME="${libName}"

  CRATE_NAME='${lib.replaceStrings [ "-" ] [ "_" ] libName}'

  setup_link_paths

  if [[ -e "$LIB_PATH" ]]; then
     build_lib "$LIB_PATH"
     ${lib.optionalString buildTests ''build_lib_test "$LIB_PATH"''}
  elif [[ -e src/lib.rs ]]; then
     build_lib src/lib.rs
     ${lib.optionalString buildTests "build_lib_test src/lib.rs"}
  fi



  ${lib.optionalString (crateBin != [ ]) (
    lib.concatMapStringsSep "\n" (
      bin:
      let
        haveRequiredFeature =
          if bin ? requiredFeatures then
            # Check that all element in requiredFeatures are also present in crateFeatures
            lib.intersectLists bin.requiredFeatures crateFeatures == bin.requiredFeatures
          else
            true;
      in
      if haveRequiredFeature then
        ''
          mkdir -p target/bin
          BIN_NAME='${bin.name or crateName}'
          ${
            if !bin ? path then
              ''
                BIN_PATH=""
                search_for_bin_path "$BIN_NAME"
              ''
            else
              ''
                BIN_PATH='${bin.path}'
              ''
          }
            ${build_bin} "$BIN_NAME" "$BIN_PATH"
        ''
      else
        ''
          echo Binary ${bin.name or crateName} not compiled due to not having all of the required features -- ${lib.escapeShellArg (builtins.toJSON bin.requiredFeatures)} -- enabled.
        ''
    ) crateBin
  )}

  ${lib.optionalString buildTests ''
    # When tests are enabled build all the files in the `tests` directory as
    # test binaries.
    if [ -d tests ]; then
      # find all the .rs files (or symlinks to those) in the tests directory, no subdirectories
      find tests -maxdepth 1 \( -type f -o -type l \) -a -name '*.rs' -print0 | while IFS= read -r -d ''' file; do
        mkdir -p target/bin
        build_bin_test_file "$file"
      done

      # find all the subdirectories of tests/ that contain a main.rs file as
      # that is also a test according to cargo
      find tests/ -mindepth 1 -maxdepth 2 \( -type f -o -type l \) -a -name 'main.rs' -print0 | while IFS= read -r -d ''' file; do
        mkdir -p target/bin
        build_bin_test_file "$file"
      done

    fi
  ''}

  # If crateBin is empty and hasCrateBin is not set then we must try to
  # detect some kind of bin target based on some files that might exist.
  ${lib.optionalString (crateBin == [ ] && !hasCrateBin) ''
    if [[ -e src/main.rs ]]; then
      mkdir -p target/bin
      ${build_bin} ${crateName} src/main.rs
    fi
    for i in src/bin/*.rs; do #*/
      mkdir -p target/bin
      ${build_bin} "$(basename $i .rs)" "$i"
    done
  ''}
  # Remove object files to avoid "wrong ELF type"
  find target -type f -name "*.o" -print0 | xargs -0 rm -f
  runHook postBuild
''
