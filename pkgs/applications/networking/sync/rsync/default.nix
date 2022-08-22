{ lib
, stdenv
, fetchurl
, perl
, libiconv
, zlib
, popt
, enableACLs ? lib.meta.availableOn stdenv.hostPlatform acl
, acl
, enableLZ4 ? true
, lz4
, enableOpenSSL ? true
, openssl
, enableXXHash ? true
, xxHash
, enableZstd ? true
, zstd
, nixosTests
, enableCopyDevicesPatch ? false
}:

let
  mkDerivation = lib.warnIf
    enableCopyDevicesPatch
    "enableCopyDevicesPatch in pkgs.rsync is not needed anymore"
    stdenv.mkDerivation;
in
mkDerivation rec {
  pname = "rsync";
  version = "3.2.5";

  src = fetchurl {
    # signed with key 0048 C8B0 26D4 C96F 0E58  9C2F 6C85 9FB1 4B96 A8C5
    url = "mirror://samba/rsync/src/rsync-${version}.tar.gz";
    sha256 = "sha256-KsTSFjXN95GGe8N3w1ym3af1DZGaWL5FBX/VFgDGmro=";
  };

  nativeBuildInputs = [ perl ];

  buildInputs = [ libiconv zlib popt ]
    ++ lib.optional enableACLs acl
    ++ lib.optional enableZstd zstd
    ++ lib.optional enableLZ4 lz4
    ++ lib.optional enableOpenSSL openssl
    ++ lib.optional enableXXHash xxHash;

  configureFlags = [
    "--with-nobody-group=nogroup"

    # disable the included zlib explicitly as it otherwise still compiles and
    # links them even.
    "--with-included-zlib=no"
  ]
  # Work around issue with cross-compilation:
  #     configure.sh: error: cannot run test program while cross compiling
  # Remove once 3.2.4 or more recent is released.
  # The following PR should fix the cross-compilation issue.
  # Test using `nix-build -A pkgsCross.aarch64-multiplatform.rsync`.
  # https://github.com/WayneD/rsync/commit/b7fab6f285ff0ff3816b109a8c3131b6ded0b484
  ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) "--enable-simd=no";

  passthru.tests = { inherit (nixosTests) rsyncd; };

  meta = with lib; {
    description = "Fast incremental file transfer utility";
    homepage = "https://rsync.samba.org/";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with lib.maintainers; [ ehmry kampfschlaefer ivan ];
  };
}
