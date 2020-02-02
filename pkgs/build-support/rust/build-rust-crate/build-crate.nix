{ lib, stdenv, echo_build_heading, noisily, mkRustcDepArgs, rust }:
{ crateName,
  dependencies,
  crateFeatures, crateRenames, libName, release, libPath,
  crateType, metadata, crateBin, hasCrateBin,
  extraRustcOpts, verbose, colors,
  buildTests
}:

  let
    baseRustcOpts =
      [(if release then "-C opt-level=3" else "-C debuginfo=2")]
      ++ ["-C codegen-units=$NIX_BUILD_CORES"]
      ++ [(mkRustcDepArgs dependencies crateRenames)]
      ++ [crateFeatures]
      ++ extraRustcOpts
      ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) "--target ${rust.toRustTarget stdenv.hostPlatform} -C linker=${stdenv.hostPlatform.config}-gcc"
    ;
    rustcMeta = "-C metadata=${metadata} -C extra-filename=-${metadata}";


    # build the final rustc arguments that can be different between different
    # crates
    libRustcOpts = lib.concatStringsSep " " (
      baseRustcOpts
      ++ [rustcMeta]
      ++ (map (x: "--crate-type ${x}") crateType)
    );

    binRustcOpts = lib.concatStringsSep " " (
      baseRustcOpts
    );

    build_bin = if buildTests then "build_bin_test" else "build_bin";
  in ''
    runHook preBuild
    ${echo_build_heading colors}
    ${noisily colors verbose}

    # configure & source common build functions
    LIB_RUSTC_OPTS="${libRustcOpts}"
    BIN_RUSTC_OPTS="${binRustcOpts}"
    LIB_EXT="${stdenv.hostPlatform.extensions.sharedLibrary}"
    LIB_PATH="${libPath}"
    LIB_NAME="${libName}"
    source ${./lib.sh}

    CRATE_NAME='${lib.replaceStrings ["-"] ["_"] libName}'

    setup_link_paths

    if [[ -e "$LIB_PATH" ]]; then
       build_lib "$LIB_PATH"
       ${lib.optionalString buildTests ''build_lib_test "$LIB_PATH"''}
    elif [[ -e src/lib.rs ]]; then
       build_lib src/lib.rs
       ${lib.optionalString buildTests "build_lib_test src/lib.rs"}
    fi



    ${lib.optionalString (lib.length crateBin > 0) (lib.concatMapStringsSep "\n" (bin: ''
      mkdir -p target/bin
      BIN_NAME='${bin.name or crateName}'
      ${if !bin ? path then ''
        BIN_PATH=""
        search_for_bin_path "$BIN_NAME"
      '' else ''
        BIN_PATH='${bin.path}'
      ''}
        ${build_bin} "$BIN_NAME" "$BIN_PATH"
    '') crateBin)}

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
    ${lib.optionalString (lib.length crateBin == 0 && !hasCrateBin) ''
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
