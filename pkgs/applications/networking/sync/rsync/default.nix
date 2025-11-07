{
  lib,
  stdenv,
  fetchpatch,
  fetchurl,
  updateAutotoolsGnuConfigScriptsHook,
  perl,
  libiconv,
  zlib,
  popt,
  enableACLs ? lib.meta.availableOn stdenv.hostPlatform acl,
  acl,
  enableLZ4 ? true,
  lz4,
  enableOpenSSL ? true,
  openssl,
  enableXXHash ? true,
  xxHash,
  enableZstd ? true,
  zstd,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "rsync";
  version = "3.4.1";

  src = fetchurl {
    # signed with key 9FEF 112D CE19 A0DC 7E88  2CB8 1BB2 4997 A853 5F6F
    url = "mirror://samba/rsync/src/rsync-${version}.tar.gz";
    hash = "sha256-KSS8s6Hti1UfwQH3QLnw/gogKxFQJ2R89phQ1l/YjFI=";
  };

  patches = [
    # See: <https://github.com/RsyncProject/rsync/pull/790>
    ./fix-tests-in-darwin-sandbox.patch
    # fix compilation with gcc15
    (fetchpatch {
      url = "https://github.com/RsyncProject/rsync/commit/a4b926dcdce96b0f2cc0dc7744e95747b233500a.patch";
      hash = "sha256-UiEQJ+p2gtIDYNJqnxx4qKgItKIZzCpkHnvsgoxBmSE=";
    })
  ];

  nativeBuildInputs = [
    updateAutotoolsGnuConfigScriptsHook
    perl
  ];

  buildInputs = [
    libiconv
    zlib
    popt
  ]
  ++ lib.optional enableACLs acl
  ++ lib.optional enableZstd zstd
  ++ lib.optional enableLZ4 lz4
  ++ lib.optional enableOpenSSL openssl
  ++ lib.optional enableXXHash xxHash;

  configureFlags = [
    (lib.enableFeature enableLZ4 "lz4")
    (lib.enableFeature enableOpenSSL "openssl")
    (lib.enableFeature enableXXHash "xxhash")
    (lib.enableFeature enableZstd "zstd")
    # Feature detection does a runtime check which varies according to ipv6
    # availability, so force it on to make reproducible, see #360152.
    (lib.enableFeature true "ipv6")
    "--with-nobody-group=nogroup"

    # disable the included zlib explicitly as it otherwise still compiles and
    # links them even.
    "--with-included-zlib=no"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isMusl && stdenv.hostPlatform.isx86_64) [
    # fix `multiversioning needs 'ifunc' which is not supported on this target` error
    "--disable-roll-simd"
  ];

  enableParallelBuilding = true;

  passthru.tests = { inherit (nixosTests) rsyncd; };

  doCheck = true;

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Fast incremental file transfer utility";
    homepage = "https://rsync.samba.org/";
    license = licenses.gpl3Plus;
    mainProgram = "rsync";
    maintainers = with lib.maintainers; [
      ivan
    ];
    platforms = platforms.unix;
    identifiers.cpeParts = {
      vendor = "samba";
      inherit version;
      update = "-";
    };
  };
}
