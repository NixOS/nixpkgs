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

stdenv.mkDerivation rec {
  pname = "rsync";
  version = "3.2.4";

  srcs = [
    (fetchurl {
      # signed with key 0048 C8B0 26D4 C96F 0E58  9C2F 6C85 9FB1 4B96 A8C5
      url = "mirror://samba/rsync/src/rsync-${version}.tar.gz";
      sha256 = "sha256-b3YYONCAUrC2V5z39nN9k+R/AfTaBMXSTTRHt/Kl+tE=";
    })
  ] ++ lib.optional enableCopyDevicesPatch (fetchurl {
    # signed with key 0048 C8B0 26D4 C96F 0E58  9C2F 6C85 9FB1 4B96 A8C5
    url = "mirror://samba/rsync/rsync-patches-${version}.tar.gz";
    sha256 = "1wj21v57v135n6fnm2m2dxmb9lhrrg62jgkggldp1gb7d6s4arny";
  });

  patches = lib.optional enableCopyDevicesPatch "./patches/copy-devices.diff";

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
  ];

  enableParallelBuilding = true;

  passthru.tests = { inherit (nixosTests) rsyncd; };

  meta = with lib; {
    description = "Fast incremental file transfer utility";
    homepage = "https://rsync.samba.org/";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with lib.maintainers; [ ehmry kampfschlaefer ];
  };
}
