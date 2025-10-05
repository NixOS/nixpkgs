{
  lib,
  stdenv,
  fetchFromGitHub,
  acl,
  attr,
  autoreconfHook,
  bzip2,
  fetchpatch,
  glibcLocalesUtf8,
  lzo,
  openssl,
  pkg-config,
  xz,
  zlib,
  zstd,
  # Optional but increases closure only negligibly. Also, while libxml2 builds
  # fine on windows, libarchive has trouble linking windows things it depends on
  # for some reason.
  xarSupport ? stdenv.hostPlatform.isUnix,
  libxml2,

  # for passthru.tests
  cmake,
  nix,
  samba,

  # for passthru.lore
  binlore,
}:

assert xarSupport -> libxml2 != null;
stdenv.mkDerivation (finalAttrs: {
  pname = "libarchive";
  version = "3.8.1";

  src = fetchFromGitHub {
    owner = "libarchive";
    repo = "libarchive";
    rev = "v${finalAttrs.version}";
    hash = "sha256-KN5SvQ+/g/OOa+hntMX3D8p5IEWO0smke5WK+DwrOH0=";
  };

  patches = [
    # https://github.com/libarchive/libarchive/pull/2689
    # Remove after next release.
    (fetchpatch {
      url = "https://github.com/libarchive/libarchive/commit/489d0b8e2f1fafd3b7ebf98f389ca67462c34651.patch?full_index=1";
      hash = "sha256-r+tSJ+WA0VKCjg+8MfS5/RqcB+aAMZ2dK0YUh+U1q78=";
    })
    # Fix the tests on Darwin when `$TMPDIR` does not end with a slash
    # and its parent directory is not writable by the build user, as on
    # Nix ≥ 2.30.0 and Lix ≥ 2.91.2, ≥ 2.92.2, ≥ 2.93.1.
    # <https://github.com/libarchive/libarchive/pull/2708>
    ./fix-darwin-tmpdir-handling.patch
  ];

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  postPatch =
    let
      skipTestPaths = [
        # test won't work in nix sandbox
        "libarchive/test/test_write_disk_perms.c"
        # the filesystem does not necessarily have sparse capabilities
        "libarchive/test/test_sparse_basic.c"
        # the filesystem does not necessarily have hardlink capabilities
        "libarchive/test/test_write_disk_hardlink.c"
        # access-time-related tests flakey on some systems
        "libarchive/test/test_read_disk_directory_traversals.c"
        "cpio/test/test_option_a.c"
        "cpio/test/test_option_t.c"
        # fails tests on filesystems with 64-bit inode values:
        # FAIL: bsdcpio_test
        #   bsdcpio: linkfile: large inode number truncated: Numerical result out of range
        "cpio/test/test_basic.c"
        "cpio/test/test_format_newc.c"
      ];
      removeTest = testPath: ''
        substituteInPlace Makefile.am --replace-fail "${testPath}" ""
        rm "${testPath}"
      '';
    in
    ''
      substituteInPlace Makefile.am --replace-fail '/bin/pwd' "$(type -P pwd)"

      ${lib.concatStringsSep "\n" (map removeTest skipTestPaths)}
    '';

  nativeBuildInputs = [
    autoreconfHook
    glibcLocalesUtf8 # test_I test requires an UTF-8 locale
    pkg-config
  ];

  buildInputs = [
    bzip2
    lzo
    openssl
    xz
    zlib
    zstd
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    acl
    attr
  ]
  ++ lib.optional xarSupport libxml2;

  # Without this, pkg-config-based dependencies are unhappy
  propagatedBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    attr
    acl
  ];

  hardeningDisable = [ "strictflexarrays3" ];

  configureFlags = lib.optional (!xarSupport) "--without-xml2";

  preBuild = lib.optionalString stdenv.hostPlatform.isCygwin ''
    echo "#include <windows.h>" >> config.h
  '';

  # https://github.com/libarchive/libarchive/issues/1475
  doCheck = !stdenv.hostPlatform.isMusl;

  preCheck = ''
    # Need an UTF-8 locale for test_I test.
    export LANG=en_US.UTF-8
  '';

  preFixup = ''
    sed -i $lib/lib/libarchive.la \
      -e 's|-lcrypto|-L${lib.getLib openssl}/lib -lcrypto|' \
      -e 's|-llzo2|-L${lzo}/lib -llzo2|'
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "http://libarchive.org";
    description = "Multi-format archive and compression library";
    longDescription = ''
      The libarchive project develops a portable, efficient C library that can
      read and write streaming archives in a variety of formats. It also
      includes implementations of the common tar, cpio, and zcat command-line
      tools that use the libarchive library.
    '';
    changelog = "https://github.com/libarchive/libarchive/releases/tag/v${finalAttrs.version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jcumming ];
    platforms = platforms.all;
    inherit (acl.meta) badPlatforms;
  };

  passthru.tests = {
    inherit cmake nix samba;
  };

  # bsdtar is detected as "cannot" because its exec is internal to
  # calls it makes into libarchive itself. If binlore gains support
  # for detecting another layer down into libraries, this can be cut.
  passthru.binlore.out = binlore.synthesize finalAttrs.finalPackage ''
    execer can bin/bsdtar
  '';
})
