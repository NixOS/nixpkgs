echo_build_heading() {
  echo_colored "Building $1 ($2 | kind: $3)"
}

# Whether to use the test harness
# https://github.com/rust-lang/cargo/blob/9282cf74a38757c217d122bbf998afcda2626595/src/cargo/core/compiler/mod.rs#L1094
use_test_harness() {
    local is_test=$1
    local use_harness=$2

    if [ $is_test -eq 1 ] && [ $use_harness -eq 1 ]; then
        echo "--test"
    elif [ $is_test -eq 1 ]; then
        echo "--cfg test"
    else
        echo ""
    fi
}

# Crate file names can be the same due to main.rs
# derive their names using subdirectories
# tests/foo/main.rs -> foo
# tests/bar/main.rs -> bar
# tests/zed.rs -> zed
derive_crate_name() {
    local file=$1
    local dir=$2

    local derived_crate_name="${file//\//_}"
    # Make sure to strip the top level `tests` directory: see #204051. Note that
    # a forward slash has now become an underscore due to the substitution
    # above.
    derived_crate_name=${derived_crate_name#"$dir_"}
    derived_crate_name="${derived_crate_name%.rs}"

    echo $derived_crate_name
}


# Call through build_lib_KIND functions
_build_lib() {
  local lib_src=$1
  local is_test=$2
  local harness=$3

  local test_flags
  test_flags=$(use_test_harness $is_test $harness)

  # OUT_DIR is for build script output, prefix CRATE
  if [ ! -d "$CRATE_OUT_DIR" ]; then
    mkdir -p "$CRATE_OUT_DIR"
  fi

  noisily rustc \
    --crate-name $CRATE_NAME \
    $lib_src \
    $test_flags \
    --out-dir "$CRATE_OUT_DIR" \
    -L dependency=target/deps \
    --cap-lints allow \
    $LINK \
    $EXTRA_LINK_ARGS \
    $EXTRA_LINK_ARGS_LIB \
    $LIB_RUSTC_OPTS \
    $BUILD_OUT_DIR \
    $EXTRA_BUILD \
    $EXTRA_FEATURES \
    $EXTRA_RUSTC_FLAGS \
    --color $colors

  EXTRA_LIB=" --extern $CRATE_NAME=target/lib/lib$CRATE_NAME-$metadata.rlib"
  if [ -e target/deps/lib$CRATE_NAME-$metadata$LIB_EXT ]; then
     EXTRA_LIB="$EXTRA_LIB --extern $CRATE_NAME=target/lib/lib$CRATE_NAME-$metadata$LIB_EXT"
  fi
}

build_lib_lib() {
    local lib_src=$1
    local is_test=0
    # harness does not matter

    echo_build_heading "$LIB_NAME" "$lib_src" "lib"
    CRATE_OUT_DIR="target/$lib_DIR" _build_lib "$lib_src" $is_test
}

build_lib_test() {
    local lib_src=$1
    local harness=$2
    local is_test=1

    echo_build_heading "$LIB_NAME" "$lib_src" "lib-test"
    CRATE_OUT_DIR="target/$test_DIR" _build_lib "$lib_src" $is_test $harness
}

build_lib_bench() {
    local lib_src=$1
    local harness=$2
    local is_test=1

    echo_build_heading "$LIB_NAME" "$lib_src" "lib-bench"
    CRATE_OUT_DIR="target/$bench_DIR" _build_lib "$lib_src" $is_test $harness
}

# Call through build_bin_KIND functions
_build_bin() {
  local crate_name=$1
  local main_file=$2
  local is_test=$3
  local harness=$4

  local test_flags=$(use_test_harness $is_test $harness)
  local crate_name_=$(echo $crate_name | tr '-' '_')

  if [ ! -d "$CRATE_OUT_DIR" ]; then
    mkdir -p "$CRATE_OUT_DIR"
  fi

  noisily rustc \
    --crate-name $crate_name_ \
    $main_file \
    $test_flags \
    --crate-type bin \
    $BIN_RUSTC_OPTS \
    --out-dir "$CRATE_OUT_DIR" \
    -L dependency=target/deps \
    $LINK \
    $EXTRA_LINK_ARGS \
    $EXTRA_LINK_ARGS_BINS \
    $EXTRA_LIB \
    --cap-lints allow \
    $BUILD_OUT_DIR \
    $EXTRA_BUILD \
    $EXTRA_FEATURES \
    $EXTRA_RUSTC_FLAGS \
    --color ${colors} \

  if [ "$crate_name_" != "$crate_name" ]; then
    mv $CRATE_OUT_DIR/$crate_name_ $CRATE_OUT_DIR/$crate_name
  fi
}

build_bin_bin() {
    local crate_name=$1
    local main_file=$2
    local is_test=0
    # harness does not matter

    echo_build_heading $crate_name $main_file "bin"
    CRATE_OUT_DIR="target/$bin_DIR" _build_bin "$crate_name" "$main_file" $is_test
}

build_bin_example() {
    local crate_name=$1
    local main_file=$2
    local is_test=0
    # harness does not matter

    echo_build_heading $crate_name $main_file "example"
    CRATE_OUT_DIR="target/$example_DIR" _build_bin "$crate_name" "$main_file" $is_test
}

build_bin_test() {
    local crate_name=$1
    local main_file=$2
    local harness=$3
    local is_test=1

    echo_build_heading $crate_name $main_file "test"
    CRATE_OUT_DIR="target/$test_DIR" _build_bin "$crate_name" "$main_file" $is_test $harness
}

build_bin_bench() {
    local crate_name=$1
    local main_file=$2
    local harness=$3
    local is_test=1

    echo_build_heading $crate_name $main_file "bench"
    CRATE_OUT_DIR="target/$bench_DIR" _build_bin "$crate_name" "$main_file" $is_test $harness
}

auto_build_bins() {
    local crateName=$1
    local buildTest=$2
    # Use harness for auto builds
    local harness=1

    echo_colored "Autodiscovering bin"

    if [ -e src/main.rs ]; then
      build_bin_bin "$crateName" "src/main.rs"
      if [ $buildTest -eq 1 ]; then
          build_bin_test "$crateName" "src/main.rs" $harness
      fi
    fi

    for file in src/bin/*.rs; do
      build_bin_bin "$(basename $file .rs)" "$file"
      if [ $buildTest -eq 1 ]; then
          # TODO: build test & build bench is the same output
          build_bin_test "$(basename $file .rs)" "$file" $harness
      fi
    done
}

auto_build_dir() {
    # directory and kind names are subtley different
    local kind=$1
    local buildTest=$2
    echo "Building tests: $1 $2"

    # Use harness for auto builds
    local harness=1
    echo_colored "Autodiscovering $kind"

    local dir
    dir="${kind}_DIR"
    dir="${!dir}"

    if [ -d "$dir" ]; then
      # find all the .rs files (or symlinks to those) in the directory, no subdirectories
      find "$dir" -maxdepth 1 \( -type f -o -type l \) -a -name '*.rs' -print0 | while IFS= read -r -d '' file; do
        local crate_name=$(derive_crate_name $file $dir)
        build_bin_$kind "$crate_name" "$file" $harness
        if [ $buildTest -eq 1 ]; then
            # TODO: build test & build bench is the same output
            build_bin_test "$crate_name" "$file" $harness
        fi
      done

      # find all the subdirectories of $dir/ that contain a main.rs file as
      # that is also a test according to cargo
      find "$dir"/ -mindepth 1 -maxdepth 2 \( -type f -o -type l \) -a -name 'main.rs' -print0 | while IFS= read -r -d '' file; do
        local crate_name=$(derive_crate_name $file $dir)
        build_bin_$kind "$crate_name" "$file" $harness
        if [ $buildTest -eq 1 ]; then
            # TODO: build test & build bench is the same output
            build_bin_test "$crate_name" "$file" $harness
        fi
      done
    fi
}

# Add additional link options that were provided by the build script.
setup_link_paths() {
  EXTRA_LIB=""
  if [[ -e target/link_ ]]; then
    EXTRA_BUILD="$(cat target/link_) $EXTRA_BUILD"
  fi

  echo "$EXTRA_LINK_SEARCH" | while read i; do
     if [[ ! -z "$i" ]]; then
       for library in $i; do
         echo "-L $library" >> target/link
         L=$(echo $library | sed -e "s#$(pwd)/target/build#$lib/lib#")
         echo "-L $L" >> target/link.final
       done
     fi
  done
  echo "$EXTRA_LINK_LIBS" | while read i; do
     if [[ ! -z "$i" ]]; then
       for library in $i; do
         echo "-l $library" >> target/link
       done
     fi
  done

  if [[ -e target/link ]]; then
     tr '\n' ' ' < target/link > target/link_
     LINK=$(cat target/link_)
  fi
}

search_for_path() {
    local kind=$1
    BIN_NAME=$2
    BIN_NAME_=$(echo $BIN_NAME | tr '-' '_')

    local dir
    dir="${kind}_DIR"
    dir="${!dir}"

    FILES=( "$dir/$BIN_NAME.rs" "$dir/$BIN_NAME/main.rs" "$dir/$BIN_NAME_/main.rs" "$dir/$BIN_NAME_/main.rs")

    for file in "${FILES[@]}";
    do
      echo "checking file $file"
      # first file that exists wins
      if [[ -e "$file" ]]; then
              BIN_PATH="$file"
              break
      fi
    done

    if [[ -z "$BIN_PATH" ]]; then
      echo_error "ERROR: failed to find file for binary target (kind: $kind): $BIN_NAME" >&2
      exit 1
    fi
}

search_for_bin_path() {
  # heuristic to "guess" the correct source file as found in cargo:
  # https://github.com/rust-lang/cargo/blob/90fc9f620190d5fa3c80b0c8c65a1e1361e6b8ae/src/cargo/util/toml/targets.rs#L308-L325

  BIN_NAME=$1
  BIN_NAME_=$(echo $BIN_NAME | tr '-' '_')

  # the first two cases are the "new" default IIRC
  FILES=( "src/bin/$BIN_NAME.rs" "src/bin/$BIN_NAME/main.rs" "src/bin/$BIN_NAME_.rs" "src/bin/$BIN_NAME_/main.rs" "src/bin/main.rs" "src/main.rs" )

  if ! [ -e "$LIB_PATH" -o -e src/lib.rs -o -e "src/$LIB_NAME.rs" ]; then
    # if this is not a library the following path is also valid
    FILES=( "src/$BIN_NAME.rs" "src/$BIN_NAME_.rs" "${FILES[@]}" )
  fi

  for file in "${FILES[@]}";
  do
    echo "checking file $file"
    # first file that exists wins
    if [[ -e "$file" ]]; then
            BIN_PATH="$file"
            break
    fi
  done

  if [[ -z "$BIN_PATH" ]]; then
    echo_error "ERROR: failed to find file for binary target: $BIN_NAME" >&2
    exit 1
  fi
}

# Extracts cargo_toml_path of the matching crate.
matching_cargo_toml_path() {
  local manifest_path="$1"
  local expected_crate_name="$2"

  # If the Cargo.toml is not a workspace root,
  # it will only contain one package in ".packages"
  # because "--no-deps" suppressed dependency resolution.
  #
  # But to make it more general, we search for a matching
  # crate in all packages and use the manifest path that
  # is referenced there.
  cargo metadata --no-deps --format-version 1 \
    --manifest-path "$manifest_path" \
    | jq -r '.packages[]
            | select( .name == "'$expected_crate_name'")
            | .manifest_path'
}

# Find a Cargo.toml in the current or any sub directory
# with a matching crate name.
matching_cargo_toml_dir() {
  local expected_crate_name="$1"

  find -L -name Cargo.toml | sort | while read manifest_path; do
    echo "...checking manifest_path $manifest_path" >&2
    local matching_path="$(matching_cargo_toml_path "$manifest_path" "$expected_crate_name")"
    if [ -n "${matching_path}" ]; then
      echo "$(dirname $matching_path)"
      break
    fi
  done
}
