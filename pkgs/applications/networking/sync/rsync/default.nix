{
  lib,
  stdenv,
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
  version = "3.3.0";

  src = fetchurl {
    # signed with key 0048 C8B0 26D4 C96F 0E58  9C2F 6C85 9FB1 4B96 A8C5
    url = "mirror://samba/rsync/src/rsync-${version}.tar.gz";
    hash = "sha256-c5nppnCMMtZ4pypjIZ6W8jvgviM25Q/RNISY0HBB35A=";
  };

  nativeBuildInputs = [
    updateAutotoolsGnuConfigScriptsHook
    perl
  ];

  patches = [
    # https://github.com/WayneD/rsync/pull/558
    ./configure.ac-fix-failing-IPv6-check.patch
  ];

  buildInputs =
    [
      libiconv
      zlib
      popt
    ]
    ++ lib.optional enableACLs acl
    ++ lib.optional enableZstd zstd
    ++ lib.optional enableLZ4 lz4
    ++ lib.optional enableOpenSSL openssl
    ++ lib.optional enableXXHash xxHash;

  configureFlags =
    [
      (lib.enableFeature enableLZ4 "lz4")
      (lib.enableFeature enableOpenSSL "openssl")
      (lib.enableFeature enableXXHash "xxhash")
      (lib.enableFeature enableZstd "zstd")
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

  meta = with lib; {
    description = "Fast incremental file transfer utility";
    homepage = "https://rsync.samba.org/";
    license = licenses.gpl3Plus;
    mainProgram = "rsync";
    maintainers = with lib.maintainers; [
      ehmry
      kampfschlaefer
      ivan
    ];
    platforms = platforms.unix;
  };
}
