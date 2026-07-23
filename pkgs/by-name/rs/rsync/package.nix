{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,

  updateAutotoolsGnuConfigScriptsHook,
  perl,
  python3,
  libiconv,
  zlib,
  popt,

  config,

  enableACLs ? config.rsync.enableACLs or (lib.meta.availableOn stdenv.hostPlatform acl),
  acl,
  enableLZ4 ? config.rsync.enableLZ4 or true,
  lz4,
  enableOpenSSL ? config.rsync.enableOpenSSL or true,
  openssl,
  enableXXHash ? config.rsync.enableXXHash or true,
  xxhash,
  enableZstd ? config.rsync.enableZstd or true,
  zstd,

  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rsync";
  version = "3.4.4";

  src = fetchurl {
    # signed with key 9FEF 112D CE19 A0DC 7E88  2CB8 1BB2 4997 A853 5F6F
    url = "mirror://samba/rsync/src/rsync-${finalAttrs.version}.tar.gz";
    hash = "sha256-vYjPgvplPaMjFPsikTZAfFyQ+A0XWNj0sJF2eHfY+pY=";
  };

  patches = [
    # Fixes test failure on darwin
    (fetchpatch {
      url = "https://github.com/RsyncProject/rsync/commit/e1c5f0e93a75dd45f32f3b92ba221ef158ac2e5f.patch";
      hash = "sha256-pg65K9BCTq/WvS5icK6KT28ARccFKedp2445wLYdRsE=";
      excludes = [
        ".github/workflows/cygwin-build.yml"
      ];
    })
  ];

  preBuild = ''
    patchShebangs ./runtests.py
  '';

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
  ++ lib.optional enableXXHash xxhash;

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

  nativeCheckInputs = [
    python3
  ];

  # Test fails when built in a chroot store
  preCheck = ''
    rm testsuite/chgrp.test
  '';

  doCheck = true;

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Fast incremental file transfer utility";
    homepage = "https://rsync.samba.org/";
    license = lib.licenses.gpl3Plus;
    mainProgram = "rsync";
    maintainers = [
    ];
    teams = [ lib.teams.security-review ];
    platforms = lib.platforms.unix;
    identifiers.cpeParts = {
      vendor = "samba";
      inherit (finalAttrs) version;
      update = "-";
    };
  };
})
