{ lib, stdenv, echo_build_heading, noisily, makeDeps }:
{ crateName,
  dependencies,
  crateFeatures, libName, release, libPath,
  crateType, metadata, crateBin, hasCrateBin,
  extraRustcOpts, verbose, colors }:

  let

    deps = makeDeps dependencies;
    rustcOpts =
      lib.lists.foldl' (opts: opt: opts + " " + opt)
        (if release then "-C opt-level=3" else "-C debuginfo=2")
        (["-C codegen-units=1"] ++ extraRustcOpts);
    rustcMeta = "-C metadata=${metadata} -C extra-filename=-${metadata}";

    # Some platforms have different names for rustc.
    rustPlatform =
      with stdenv.hostPlatform.parsed;
      let cpu_ = if cpu.name == "armv7a" then "armv7"
                 else cpu.name;
          vendor_ = vendor.name;
          kernel_ = kernel.name;
          abi_ = abi.name;
      in
      "${cpu_}-${vendor_}-${kernel_}-${abi_}";
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

       noisily rustc --crate-name $CRATE_NAME $lib_src \
         ${lib.strings.concatStrings (map (x: " --crate-type ${x}") crateType)}  \
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
        $BUILD_OUT_DIR $EXTRA_BUILD $EXTRA_FEATURES --color ${colors} \
        ${if stdenv.hostPlatform != stdenv.buildPlatform then "--target ${rustPlatform} -C linker=${stdenv.hostPlatform.config}-gcc" else ""}
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
    ${lib.optionalString (crateBin != "") ''
    printf "%s\n" "${crateBin}" | head -n1 | tr -s ',' '\n' | while read -r BIN_NAME BIN_PATH; do
      mkdir -p target/bin
      # filter empty entries / empty "lines"
      if [[ -z "$BIN_NAME" ]]; then
           continue
      fi

      if [[ -z "$BIN_PATH" ]]; then
        # heuristic to "guess" the correct source file as found in cargo:
        # https://github.com/rust-lang/cargo/blob/90fc9f620190d5fa3c80b0c8c65a1e1361e6b8ae/src/cargo/util/toml/targets.rs#L308-L325

        # the first two cases are the "new" default IIRC
        BIN_NAME_=$(echo $BIN_NAME | sed -e 's/-/_/g')
        FILES=( "src/bin/$BIN_NAME.rs" "src/bin/$BIN_NAME/main.rs" "src/bin/$BIN_NAME_.rs" "src/bin/$BIN_NAME_/main.rs" "src/bin/main.rs" "src/main.rs" )

        if ! [ -e "${libPath}" -o -e src/lib.rs -o -e "src/${libName}.rs" ]; then
          # if this is not a library the following path is also valid
          FILES=( "src/$BIN_NAME.rs" "src/$BIN_NAME_.rs" "''${FILES[@]}" )
        fi

        for file in "''${FILES[@]}";
        do
          echo "checking file $file"
          # first file that exists wins
          if [[ -e "$file" ]]; then
                  BIN_PATH="$file"
                  break
          fi
        done

        if [[ -z "$BIN_PATH" ]]; then
          echo "failed to find file for binary target: $BIN_NAME" >&2
          exit 1
        fi
      fi
      build_bin "$BIN_NAME" "$BIN_PATH"
    done
    ''}

    ${lib.optionalString (crateBin == "" && !hasCrateBin) ''
      if [[ -e src/main.rs ]]; then
        mkdir -p target/bin
        build_bin ${crateName} src/main.rs
      fi
      for i in src/bin/*.rs; do #*/
        mkdir -p target/bin
        build_bin "$(basename $i .rs)" "$i"
      done
    ''}
    # Remove object files to avoid "wrong ELF type"
    find target -type f -name "*.o" -print0 | xargs -0 rm -f
    runHook postBuild
  ''
