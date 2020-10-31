{ stdenv, fetchurl, perl, libiconv, zlib, popt
, enableACLs ? !(stdenv.isDarwin || stdenv.isSunOS || stdenv.isFreeBSD), acl ? null
, enableLZ4 ? true, lz4 ? null
, enableOpenSSL ? true, openssl ? null
, enableXXHash ? true, xxHash ? null
, enableZstd ? true, zstd ? null
, enableCopyDevicesPatch ? false
, nixosTests
}:

assert enableACLs -> acl != null;
assert enableLZ4 -> lz4 != null;
assert enableOpenSSL -> openssl != null;
assert enableXXHash -> xxHash != null;
assert enableZstd -> zstd != null;

let
  base = import ./base.nix { inherit stdenv fetchurl; };
in
stdenv.mkDerivation rec {
  name = "rsync-${base.version}";

  mainSrc = base.src;

  patchesSrc = base.upstreamPatchTarball;

  srcs = [mainSrc] ++ stdenv.lib.optional enableCopyDevicesPatch patchesSrc;
  patches = stdenv.lib.optional enableCopyDevicesPatch "./patches/copy-devices.diff";

  buildInputs = [libiconv zlib popt]
                ++ stdenv.lib.optional enableACLs acl
                ++ stdenv.lib.optional enableZstd zstd
                ++ stdenv.lib.optional enableLZ4 lz4
                ++ stdenv.lib.optional enableOpenSSL openssl
                ++ stdenv.lib.optional enableXXHash xxHash;
  nativeBuildInputs = [perl];

  configureFlags = ["--with-nobody-group=nogroup"]
    # Work around issue with cross-compilation:
    #     configure.sh: error: cannot run test program while cross compiling
    # Remove once 3.2.4 or more recent is released.
    # The following PR should fix the cross-compilation issue.
    # Test using `nix-build -A pkgsCross.aarch64-multiplatform.rsync`.
    # https://github.com/WayneD/rsync/commit/b7fab6f285ff0ff3816b109a8c3131b6ded0b484
    ++ stdenv.lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) "--enable-simd=no"
  ;

  passthru.tests = { inherit (nixosTests) rsyncd; };

  meta = base.meta // {
    description = "A fast incremental file transfer utility";
    maintainers = with stdenv.lib.maintainers; [ peti ehmry kampfschlaefer ];
  };
}
