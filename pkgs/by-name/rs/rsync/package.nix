{
  lib,
  stdenv,
  fetchurl,

  updateAutotoolsGnuConfigScriptsHook,
  bashNonInteractive,
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
  version = "3.5.0";

  src = fetchurl {
    # signed with key 9FEF 112D CE19 A0DC 7E88  2CB8 1BB2 4997 A853 5F6F
    url = "mirror://samba/rsync/src/rsync-${finalAttrs.version}.tar.gz";
    hash = "sha256-x//R72U+mVQPZh5HywC3+crR7muXI5mxb5PWcmVuDTM=";
  };

  patches = [ ];

  # Remove with the first upstream release that links t_acl against the snprintf fallback.
  postPatch = ''
    substituteInPlace Makefile.in \
      --replace-fail 'T_ACL_OBJ = t_acl.o lib/acl.o' 'T_ACL_OBJ = t_acl.o lib/acl.o lib/snprintf.o'
  '';

  preBuild = ''
    patchShebangs ./runtests.py ./support/rrsync

    # patchShebangs ignores non-executable test sources and embedded shebangs.
    substituteInPlace \
      testsuite/{daemon-namecvt-{empty-response,newline-token},rrsync-{sender-parent-pin,symlink}}_test.py \
      --replace-fail '#!/usr/bin/env python3' '#!${python3}/bin/python3'

    substituteInPlace \
      testsuite/rsync-ssl-stunnel-{ca-required,hostname-check}_test.py \
      --replace-fail '#!/usr/bin/env bash' '#!${stdenv.shell}'
  '';

  nativeBuildInputs = [
    updateAutotoolsGnuConfigScriptsHook
    perl
  ];

  buildInputs = [
    bashNonInteractive
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
  ]
  # Linux can hard-link symlinks; configure defaults this check to "no" when
  # cross-compiling (e.g. pkgsStatic) because it cannot run the probe.
  # That leaves hardlink_symlinks false while itemize still reports identical
  # --copy-dest/--link-dest symlinks with blank attribute flags, so
  # testsuite/itemize.test fails (https://github.com/NixOS/nixpkgs/issues/537437).
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform != stdenv.buildPlatform) [
    "rsync_cv_can_hardlink_symlink=yes"
  ];

  enableParallelBuilding = true;

  passthru.tests = { inherit (nixosTests) rsyncd; };

  nativeCheckInputs = [
    python3
  ];

  # These require set-id, chown, xattrs, or unrestricted /proc/self/fd,
  # which the Linux Nix build sandbox does not provide.
  preCheck = ''
    export RSYNC_EXCLUDE=${
      lib.concatStringsSep "," (
        lib.optionals stdenv.hostPlatform.isLinux [
          "chmod-option"
          "chmod-setid"
          "chown-fake"
          "fake-super-backup-fifo-regression"
          "protected-regular"
          "rrsync-backup-dir-inband-pivot"
          "rrsync-pull-delivers-content"
          "variety-symlink-traversal"
          "variety"
        ]
        # The Darwin sandbox drops set-id bits, and Python's os.getgroups()
        # reports account groups that may not be usable by this process.
        ++ lib.optionals stdenv.hostPlatform.isDarwin [
          "chmod-setid"
          "daemon-groupmap-wild"
        ]
        # This test assumes that every Linux libc provides glibc malloc stats.
        ++ lib.optional stdenv.hostPlatform.isMusl "misc-coverage"
        # These require a native compiler and dynamic interposition.
        ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
          "link-dest-symlink-enotsup"
          "partial-protected-regular-retry-linux"
        ]
      )
    }
  '';

  doCheck = true;
  strictDeps = true;

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Fast incremental file transfer utility";
    homepage = "https://rsync.samba.org/";
    changelog = "https://download.samba.org/pub/rsync/NEWS#${finalAttrs.version}";
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
