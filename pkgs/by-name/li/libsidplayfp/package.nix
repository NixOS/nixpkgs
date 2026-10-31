{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  makeFontsConf,
  gitUpdater,
  testers,
  autoreconfHook,
  docSupport ? true,
  doxygen,
  graphviz,
  libexsid,
  libgcrypt,
  libusb1,
  perl,
  pkg-config,
  xa,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libsidplayfp";
  version = "2.16.1";

  src = fetchFromGitHub {
    owner = "libsidplayfp";
    repo = "libsidplayfp";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-gOnLjOw9TN2b0ne7Otm5DZhV/2D1xjLxwnaYilnlBgc=";
  };

  outputs = [ "out" ] ++ lib.optionals docSupport [ "doc" ];

  patches = [
    (fetchpatch {
      name = "0001-libsidplayfp-CVE-2026-111148.patch";
      url = "https://github.com/libsidplayfp/libsidplayfp/commit/20413d5df77bf74bbeed50b10fce19826c9d4b00.patch";
      # Was fixed after v5 SID support was added, which can have a non-zero trailer length. For SIDs before that, always zero.
      # Class member was renamed fileOffset -> m_fileOffset in 3.1.0
      postFetch = ''
        substituteInPlace $out \
          --replace-fail '(m_fileOffset + m_trailerLen)' 'fileOffset'
      '';
      hash = "sha256-nQv4vDbFoLAsNshlBxN1SiAsCjee/u0doRch75HVRFA=";
    })
  ];

  postPatch = ''
    patchShebangs .
  '';

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    perl
    pkg-config
    xa
  ]
  ++ lib.optionals docSupport [
    doxygen
    graphviz
  ];

  buildInputs = [
    libexsid
    libgcrypt
    libusb1
  ];

  enableParallelBuilding = true;

  configureFlags = [
    (lib.strings.enableFeature true "hardsid")
    (lib.strings.withFeature true "gcrypt")
    (lib.strings.withFeature true "exsid")
    (lib.strings.withFeature true "usbsid")
    # Supposedly runtime detection only supported on GCC
    # https://github.com/libsidplayfp/libsidplayfp/commit/65874166b14d44467782d2996f7b644fbde0ee87
    # __builtin_cpu_supports on GCC's list of x86 built-in functions
    (lib.strings.withFeatureAs true "simd" (
      if (stdenv.cc.isGNU && stdenv.hostPlatform.isx86) then "runtime" else "none"
    ))
    (lib.strings.enableFeature finalAttrs.finalPackage.doCheck "tests")
  ];

  # Make Doxygen happy with the setup, reduce log noise
  env.FONTCONFIG_FILE = lib.optionalString docSupport (makeFontsConf {
    fontDirectories = [ ];
  });

  preBuild = ''
    # Reduce noise from fontconfig during doc building
    export XDG_CACHE_HOME=$TMPDIR
  '';

  buildFlags = [ "all" ] ++ lib.optionals docSupport [ "doc" ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  postInstall = lib.optionalString docSupport ''
    mkdir -p $doc/share/doc/libsidplayfp
    mv docs/html $doc/share/doc/libsidplayfp/
  '';

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater {
      rev-prefix = "v";
      ignoredVersions = "[a-zA-Z]";
    };
  };

  meta = {
    description = "Library to play Commodore 64 music derived from libsidplay2";
    longDescription = ''
      libsidplayfp is a C64 music player library which integrates
      the reSID SID chip emulation into a cycle-based emulator
      environment, constantly aiming to improve emulation of the
      C64 system and the SID chips.
    '';
    homepage = "https://github.com/libsidplayfp/libsidplayfp";
    changelog = "https://github.com/libsidplayfp/libsidplayfp/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [ gpl2Plus ];
    maintainers = with lib.maintainers; [
      ramkromberg
      OPNA2608
    ];
    platforms = lib.platforms.all;
    pkgConfigModules = [
      "libsidplayfp"
      "libstilview"
    ];
  };
})
