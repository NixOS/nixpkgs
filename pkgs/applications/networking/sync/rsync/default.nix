{ lib
, stdenv
, fetchurl
, fetchpatch
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
, enableCopyDevicesPatch ? false
, nixosTests
}:

let
  base = import ./base.nix { inherit lib fetchurl fetchpatch; };
in
stdenv.mkDerivation rec {
  pname = "rsync";
  version = base.version;

  mainSrc = base.src;

  patchesSrc = base.upstreamPatchTarball;

  srcs = [ mainSrc ] ++ lib.optional enableCopyDevicesPatch patchesSrc;
  patches = lib.optional enableCopyDevicesPatch "./patches/copy-devices.diff";

  buildInputs = [ libiconv zlib popt ]
    ++ lib.optional enableACLs acl
    ++ lib.optional enableZstd zstd
    ++ lib.optional enableLZ4 lz4
    ++ lib.optional enableOpenSSL openssl
    ++ lib.optional enableXXHash xxHash;
  nativeBuildInputs = [ perl ];

  configureFlags = [
    "--with-nobody-group=nogroup"

    # disable the included zlib explicitly as it otherwise still compiles and
    # links them even.
    "--with-included-zlib=no"
  ];

  passthru.tests = { inherit (nixosTests) rsyncd; };

  meta = base.meta // {
    description = "A fast incremental file transfer utility";
    maintainers = with lib.maintainers; [ ehmry kampfschlaefer ];
  };
}
