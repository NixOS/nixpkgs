cargoSetupPostUnpackHook() {
    echo "Executing cargoSetupPostUnpackHook"

    # Some cargo builds include build hooks that modify their own vendor
    # dependencies. This copies the vendor directory into the build tree and makes
    # it writable. If we're using a tarball, the unpackFile hook already handles
    # this for us automatically.
    if [ -z $cargoVendorDir ]; then
        if [ -d "$cargoDeps" ]; then
            local dest=$(stripHash "$cargoDeps")
            cp -Lr --reflink=auto -- "$cargoDeps" "$dest"
            chmod -R +644 -- "$dest"
        else
            unpackFile "$cargoDeps"
        fi
        export cargoDepsCopy="$(realpath "$(stripHash $cargoDeps)")"
    else
        cargoDepsCopy="$(realpath "$(pwd)/$sourceRoot/${cargoRoot:+$cargoRoot/}${cargoVendorDir}")"
    fi

    if [ ! -d .cargo ]; then
        mkdir .cargo
    fi

    config="$cargoDepsCopy/.cargo/config.toml"
    if [[ ! -e $config ]]; then
      config=@defaultConfig@
    fi;

    tmp_config=$(mktemp)
    substitute $config $tmp_config \
      --subst-var-by vendor "$cargoDepsCopy"
    cat ${tmp_config} >> .cargo/config.toml

    cat >> .cargo/config.toml <<'EOF'
    @cargoConfig@
EOF

    echo "Finished cargoSetupPostUnpackHook"
}

# After unpacking and applying patches, check that the Cargo.lock matches our
# src package. Note that we do this after the patchPhase, because the
# patchPhase may create the Cargo.lock if upstream has not shipped one.
cargoSetupPostPatchHook() {
    echo "Executing cargoSetupPostPatchHook"

    cargoDepsLockfile="$cargoDepsCopy/Cargo.lock"
    srcLockfile="$(pwd)/${cargoRoot:+$cargoRoot/}Cargo.lock"

    echo "Validating consistency between $srcLockfile and $cargoDepsLockfile"
    if ! @diff@ $srcLockfile $cargoDepsLockfile; then

      # If the diff failed, first double-check that the file exists, so we can
      # give a friendlier error msg.
      if ! [ -e $srcLockfile ]; then
        echo "ERROR: Missing Cargo.lock from src. Expected to find it at: $srcLockfile"
        echo "Hint: You can use the cargoPatches attribute to add a Cargo.lock manually to the build."
        exit 1
      fi

      if ! [ -e $cargoDepsLockfile ]; then
        echo "ERROR: Missing lockfile from cargo vendor. Expected to find it at: $cargoDepsLockfile"
        exit 1
      fi

      echo
      echo "ERROR: cargoHash or cargoSha256 is out of date"
      echo
      echo "Cargo.lock is not the same in $cargoDepsCopy"
      echo
      echo "To fix the issue:"
      echo '1. Set cargoHash/cargoSha256 to an empty string: `cargoHash = "";`'
      echo '2. Build the derivation and wait for it to fail with a hash mismatch'
      echo '3. Copy the "got: sha256-..." value back into the cargoHash field'
      echo '   You should have: cargoHash = "sha256-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX=";'
      echo

      exit 1
    fi

    unset cargoDepsCopy

    echo "Finished cargoSetupPostPatchHook"
}

if [ -z "${dontCargoSetupPostUnpack-}" ]; then
  postUnpackHooks+=(cargoSetupPostUnpackHook)
fi

if [ -z ${cargoVendorDir-} ]; then
  postPatchHooks+=(cargoSetupPostPatchHook)
fi
