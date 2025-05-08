{
  lib,
  stdenv,
  fetchurl,
  nixosTests,
  autoreconfHook,
  pkg-config,
  flex,
  check,
  pam,
  coreutils,
  gzip,
  bzip2,
  xz,
  zstd,
  bash,
  gitUpdater,
  # This might be worthwhile to disable if the store lives on a compressed filesystem.
  withCompression ? true,
  # Allow disabling the unicode_start/unicode_stop utilities, which
  # unfortunately pull in bash into the closure.
  withScripts ? true,
}:

stdenv.mkDerivation rec {
  strictDeps = true;

  pname = "kbd";
  version = "2.7.1";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/kbd/${pname}-${version}.tar.xz";
    sha256 = "sha256-8WfYmdkrVszxL29JNVFz+ThwqV8V2K7r9f3NKKYhrKg=";
  };

  # vlock is moved into its own output, since it depends on pam. This
  # reduces closure size for most use cases.
  outputs = [
    "out"
    "vlock"
    "dev"
  ];

  configureFlags =
    [
      "--enable-optional-progs"
      "--enable-libkeymap"
      "--disable-nls"
    ]
    # Compression support is otherwise autodetected because gzip et
    # al. are in stdenv.
    ++ lib.optionals (!withCompression) [
      "--disable-compress"
    ]
    ++ lib.optionals (!lib.systems.equals stdenv.buildPlatform stdenv.hostPlatform) [
      "ac_cv_func_malloc_0_nonnull=yes"
      "ac_cv_func_realloc_0_nonnull=yes"
    ];

  patches = [
    ./search-paths.patch
  ];

  postPatch =
    ''
      # Renaming keymaps with name clashes, because loadkeys just picks
      # the first keymap it sees. The clashing names lead to e.g.
      # "loadkeys no" defaulting to a Norwegian Dvorak map instead of
      # the much more common QWERTY one.
      pushd data/keymaps/i386
      mv qwertz/cz{,-qwertz}.map
      mv olpc/es{,-olpc}.map
      mv olpc/pt{,-olpc}.map
      mv fgGIod/trf{,-fgGIod}.map
      mv colemak/{en-latin9,colemak}.map
      popd

    ''
    + lib.optionalString withCompression ''
      # Fix paths to decompressors. Trailing space to avoid replacing `xz` in `".xz"`.
      substituteInPlace src/libkbdfile/kbdfile.c \
        --replace-fail 'gzip '  '${gzip}/bin/gzip ' \
        --replace-fail 'bzip2 ' '${bzip2.bin}/bin/bzip2 ' \
        --replace-fail 'xz '    '${xz.bin}/bin/xz ' \
        --replace-fail 'zstd '  '${zstd.bin}/bin/zstd '
    ''
    + ''

      sed -i '
        1i prefix:=$(vlock)
        1i bindir := $(vlock)/bin' \
        src/vlock/Makefile.in \
        src/vlock/Makefile.am
    ''
    + lib.optionalString (!withScripts) ''
      substituteInPlace src/Makefile.am \
        --replace-fail 'dist_bin_SCRIPTS = unicode_start unicode_stop' 'dist_bin_SCRIPTS ='
    '';

  postInstall = lib.optionalString withScripts ''
    for i in $out/bin/unicode_{start,stop}; do
      substituteInPlace "$i" \
        --replace /usr/bin/tty ${coreutils}/bin/tty
    done
  '';

  buildInputs =
    [
      check
      pam
    ]
    ++ lib.optionals (withScripts) [
      # We install shell scripts as well. Due to strictDeps we must be
      # explicit with the buildInputs.
      bash
    ]
    ++ lib.optionals (withCompression) [
      gzip
      bzip2
      xz
      zstd
    ];

  # There are two ways how bash is pulled into the closure. One is the
  # obvious route via scripts. The other path is compression support,
  # because it actually shells out to gzip, xz, etc.
  disallowedReferences = lib.optionals (!withScripts && !withCompression) [
    bash
  ];

  enableParallelBuilding = true;

  NIX_LDFLAGS = lib.optional stdenv.hostPlatform.isStatic "-laudit";
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    flex
  ];

  passthru =
    {
      updateScript = gitUpdater {
        # No nicer place to find latest release.
        url = "https://github.com/legionus/kbd.git";
        rev-prefix = "v";
      };

      tests = {
        inherit (nixosTests) keymap kbd-setfont-decompress kbd-update-search-paths-patch;
      };
    }
    // lib.optionalAttrs withCompression {
      inherit gzip;
    };

  meta = with lib; {
    homepage = "https://kbd-project.org/";
    description = "Linux keyboard tools and keyboard maps";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ davidak ];
  };
}
