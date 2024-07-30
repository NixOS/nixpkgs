{ zstd
, fetchurl
, lib
, chromiumVersionAtLeast
}:

{ version
, hash ? ""
} @ args:

fetchurl ({
  name = "chromium-${version}.tar.zstd";
  url = "https://commondatastorage.googleapis.com/chromium-browser-official/chromium-${version}.tar.xz";
  inherit hash;

  # chromium xz tarballs are multiple gigabytes big and are sometimes downloaded multiples
  # times for different versions as part of our update script.
  # We originally inherited fetchzip's default for downloadToTemp (true).
  # Given the size of the /run/user tmpfs used defaults to logind's RuntimeDirectorySize=,
  # which in turn defaults to 10% of the total amount of physical RAM, this often lead to
  # "no space left" errors, eventually resulting in its own section in our chromium
  # README.md (for users wanting to run the update script).
  # Nowadays, we use fetchurl instead of fetchzip, which defaults to false instead of true.
  # We just want to be explicit and provide a place to document the history and reasoning
  # behind this.
  downloadToTemp = false;

  nativeBuildInputs = [ zstd ];

  postFetch = ''
    cat "$downloadedFile" \
    | xz -d --threads=$NIX_BUILD_CORES \
    | tar xf - \
      --warning=no-timestamp \
      --one-top-level=source \
      --exclude=third_party/llvm \
      --exclude=third_party/rust-src \
      --exclude='build/linux/debian_*-sysroot' \
    '' + lib.optionalString (chromiumVersionAtLeast "127") ''
      --exclude='*.tar.[a-zA-Z0-9][a-zA-Z0-9]' \
      --exclude='*.tar.[a-zA-Z0-9][a-zA-Z0-9][a-zA-Z0-9]' \
      --exclude=third_party/llvm-build \
      --exclude=third_party/rust-toolchain \
      --exclude=third_party/instrumented_libs \
    '' + ''
      --strip-components=1

    tar \
      --use-compress-program "zstd -T$NIX_BUILD_CORES" \
      --sort name \
      --mtime "1970-01-01" \
      --owner=root --group=root \
      --numeric-owner --mode=go=rX,u+rw,a-s \
      -cf $out source
  '';
} // removeAttrs args [ "version" ])
