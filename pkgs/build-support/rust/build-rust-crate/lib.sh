echo_build_heading() {
  if (( $# == 1 )); then
    echo_colored "Building $1"
  else
    echo_colored "Building $1 ($2)"
  fi
}

build_lib() {
  lib_src=$1
  echo_build_heading $lib_src ${libName}

  noisily rustc \
    --crate-name $CRATE_NAME \
    $lib_src \
    --out-dir target/lib \
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

build_bin() {
  local crate_name=$1
  local crate_name_=$(echo $crate_name | tr '-' '_')
  local main_file=""

  if [[ ! -z $2 ]]; then
    main_file=$2
  fi
  echo_build_heading $@
  noisily rustc \
    --crate-name $crate_name_ \
    $main_file \
    --crate-type bin \
    $BIN_RUSTC_OPTS \
    --out-dir target/bin \
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
    if [ -f "target/bin/$crate_name_.wasm" ]; then
      mv target/bin/$crate_name_.wasm target/bin/$crate_name.wasm
    else
      mv target/bin/$crate_name_ target/bin/$crate_name
    fi
  fi
}

build_lib_test() {
    local file="$1"
    EXTRA_RUSTC_FLAGS="--test $EXTRA_RUSTC_FLAGS" build_lib "$1" "$2"
}

build_bin_test() {
    local crate="$1"
    local file="$2"
    EXTRA_RUSTC_FLAGS="--test $EXTRA_RUSTC_FLAGS" build_bin "$1" "$2"
}

build_bin_test_file() {
    local file="$1"
    local derived_crate_name="${file//\//_}"
    # Make sure to strip the top level `tests` directory: see #204051. Note that
    # a forward slash has now become an underscore due to the substitution
    # above.
    derived_crate_name=${derived_crate_name#"tests_"}
    derived_crate_name="${derived_crate_name%.rs}"
    build_bin_test "$derived_crate_name" "$file"
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

  # Add "rustc-cdylib-link-arg" as linker arguments
  # https://doc.rust-lang.org/cargo/reference/build-scripts.html#rustc-cdylib-link-arg
  if [[ -n "$CRATE_TYPE_IS_CDYLIB" ]]; then
    EXTRA_BUILD+=" $EXTRA_CDYLIB_LINK_ARGS"
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
