{
  lib,
  stdenv,
  fetchgit,
  nixosTests,
  autoreconfHook,
  pkg-config,
  flex,
  perl,
  bison,
  autoPatchelfHook,
  check,
  pam,
  bash,
  bashNonInteractive,
  coreutils,
  zlib,
  bzip2,
  xz,
  zstd,
  gitUpdater,
  pkgsCross,
  withVlock ? true,
}:

stdenv.mkDerivation {
  pname = "kbd";
  version = "2.8.0-unstable-2025-08-12";

  __structuredAttrs = true;

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/legion/kbd.git";
    rev = "46295167a55643e941c8cdcfd2cb76bd138c851c";
    hash = "sha256-m1aVfsEme/BnyJogOPvGcOrSJfli8B/TrGxOm4POt0w=";
  };

  # vlock is moved into its own output, since it depends on pam. This
  # reduces closure size for most use cases.
  outputs = [
    "out"
    "dev"
    "scripts"
    "man"
  ]
  ++ lib.optionals withVlock [
    "vlock"
  ];

  patches = [
    ./search-paths.patch
  ];

  postPatch = ''
    # Renaming keymaps with name clashes, because loadkeys just picks
    # the first keymap it sees. The clashing names lead to e.g.
    # "loadkeys no" defaulting to a norwegian dvorak map instead of
    # the much more common qwerty one.
    pushd data/keymaps/i386
    mv qwertz/cz{,-qwertz}.map
    mv olpc/es{,-olpc}.map
    mv olpc/pt{,-olpc}.map
    mv fgGIod/trf{,-fgGIod}.map
    mv colemak/{en-latin9,colemak}.map
    popd
  '';

  preConfigure = ''
    # Perl and Bash only used during build time
    patchShebangs --build contrib/
  '';

  configureFlags = [
    "--enable-optional-progs"
    "--enable-libkeymap"
    "--disable-nls"
    (lib.enableFeature withVlock "vlock")
  ]
  ++ lib.optionals (!lib.systems.equals stdenv.buildPlatform stdenv.hostPlatform) [
    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
  ];

  strictDeps = true;
  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    flex
    perl
    bison
    autoPatchelfHook # for patching dlopen()
  ];

  nativeCheckInputs = [
    check
  ];

  buildInputs = [
    zlib
    bzip2
    xz
    zstd
    bash
  ]
  ++ lib.optionals withVlock [ pam ];

  postInstall = ''
    substituteInPlace $out/bin/unicode_{start,stop} \
      --replace-fail /usr/bin/tty ${coreutils}/bin/tty

    moveToOutput bin/unicode_start $scripts
    moveToOutput bin/unicode_stop $scripts
  ''
  + lib.optionalString withVlock ''
    moveToOutput bin/vlock $vlock
    moveToOutput etc/pam.d/vlock $vlock
  '';

  outputChecks.out.disallowedRequisites = [
    bash
    bashNonInteractive
  ];

  passthru = {
    updateScript = gitUpdater {
      # No nicer place to find latest release.
      url = "https://github.com/legionus/kbd.git";
      rev-prefix = "v";
    };
    tests = {
      cross =
        let
          systemString = if stdenv.buildPlatform.isAarch64 then "gnu64" else "aarch64-multiplatform";
        in
        pkgsCross.${systemString}.kbd;
      inherit (nixosTests) keymap kbd-setfont-decompress kbd-update-search-paths-patch;
    };
  };

  meta = {
    homepage = "https://kbd-project.org/";
    description = "Linux keyboard tools and keyboard maps";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ davidak ];
  };
}
