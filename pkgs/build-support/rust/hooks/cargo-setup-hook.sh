cargoSetupPostUnpackHook() {
    echo "Executing cargoSetupPostUnpackHook"

    eval "${cargoDepsHook-}"

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

cargoUseSystemLibs() {
  # Sentinel directory that doesn't exist. For packages
  # Where you tell it directories, but can't force it to only
  # use system libraries
  #
  # Note that this isn't perfect, as some have fallbacks if their probing fails.
  local -r sentinel_dir="$(mktemp -du nixpkgs.XXXX)/use/system/library"

  # https://github.com/aws/aws-lc-rs/blob/741dbf573a64b6a1e1e6b7c1131a0f8153a28441/aws-lc-sys/README.md#automatic-detection
  export AWS_LC_SYS_USE_SYSTEM="1"

  # https://github.com/rust-openssl/rust-openssl/blob/b46d5ec06144795e8f9e118c44bebd392956917a/openssl-sys/build/main.rs#L53
  export OPENSSL_NO_VENDOR="1"

  # 1 = Links statically to the vendored one
  # 0 = Use pkg-config
  # https://github.com/rust-lang/libz-sys/blob/2ce3271849d85329b668e0bac9f21427ecf8aef9/build.rs#L256
  export LIBZ_SYS_STATIC="0"

  # https://github.com/rusqlite/rusqlite/blob/db83b9b08d9cab73f912501eefb8df7b100acd7d/libsqlite3-sys/build.rs#L53
  export LIBSQLITE3_SYS_USE_PKG_CONFIG="1"

  # https://github.com/gyscos/zstd-rs/blob/ad18ca4e275aed9acc3087d7c1c65d03ab67ad6e/zstd-safe/zstd-sys/build.rs#L279
  export ZSTD_SYS_USE_PKG_CONFIG="1"

  # https://github.com/rust-lang/git2-rs/blob/a00922bcdf0f78419aa5dd0d3643e73ce01672a8/libgit2-sys/build.rs#L95
  export LIBGIT2_NO_VENDOR="1"

  # https://github.com/sodiumoxide/sodiumoxide/blob/3057acb1a030ad86ed8892a223d64036ab5e8523/libsodium-sys/build.rs#L34
  export SODIUM_USE_PKG_CONFIG="1"

  # https://github.com/rust-onig/rust-onig/blob/73e63eb3eea6d93d24a4aadf7fea580287750c7d/onig_sys/build.rs#L250
  export RUSTONIG_SYSTEM_LIBONIG="1"

  # We can only supply the src dir.
  # https://github.com/nginx/ngx-rust/tree/main/nginx-sys#input-variables
  # Since we don't want to pull it in for every build, we set it to a dummy value
  # in all builds, but lets the user set it via `env.NGINX_SOURCE_DIR = nginx.src`
  export NGINX_SOURCE_DIR="${NGINX_SOURCE_DIR:-"$sentinel_dir/nginx/src"}"

  # We can only supply the lib and include dirs
  # https://github.com/duckdb/duckdb-rs/blob/ea700a79534c8e8c22a9ac685135f15c31de91d3/crates/libduckdb-sys/build.rs#L203
  # Set to sentinel by default again
  # There is also a DUCKDB_LIB_DIR var, but I think only one needs to be set.
  export DUCKDB_DOWNLOAD_LIB="0"
  export DUCKDB_INCLUDE_DIR="${DUCKDB_INCLUDE_DIR:-"$sentinel_dir/duckdb/include"}"
}

if [[ -z "${dontCargoUseSystemLibs-}" ]]; then
  preConfigureHook+=(cargoUseSystemLibs)
fi

if [ -z "${dontCargoSetupPostUnpack-}" ]; then
  postUnpackHooks+=(cargoSetupPostUnpackHook)
fi

if [ -z ${cargoVendorDir-} ]; then
  postPatchHooks+=(cargoSetupPostPatchHook)
fi
