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
  libresidfp,
  libusb1,
  perl,
  pkg-config,
  xa,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libsidplayfp";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "libsidplayfp";
    repo = "libsidplayfp";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-c2LzjFwPdk/Di9Eh6E5sBwup+DD5IPXRJYjlnSBBNJU=";
  };

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optionals docSupport [ "doc" ];

  strictDeps = true;
  __structuredAttrs = true;

  patches = [
    (fetchpatch {
      name = "0001-libsidplayfp-CVE-2026-111148.patch";
      url = "https://github.com/libsidplayfp/libsidplayfp/commit/20413d5df77bf74bbeed50b10fce19826c9d4b00.patch";
      # Was fixed after v5 SID support was added, which can have a non-zero trailer length. For SIDs before that, always zero.
      postFetch = ''
        substituteInPlace $out \
          --replace-fail '(m_fileOffset + m_trailerLen)' 'm_fileOffset'
      '';
      hash = "sha256-dJ3Umk1Lvrd97Ra+iak7ReRZSdRHO4iGC69B8J50IMc=";
    })
  ];

  postPatch = ''
    patchShebangs .
  '';

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
    libresidfp
    libusb1
  ];

  configureFlags = [
    (lib.strings.withFeature true "exsid")
    (lib.strings.withFeature true "usbsid")
    (lib.strings.enableFeature finalAttrs.finalPackage.doCheck "tests")
  ];

  enableParallelBuilding = true;

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

  # Make Doxygen happy with the setup, reduce log noise
  env.FONTCONFIG_FILE = lib.optionalString docSupport (makeFontsConf {
    fontDirectories = [ ];
  });

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
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      OPNA2608
    ];
    platforms = lib.platforms.all;
    pkgConfigModules = [
      "libsidplayfp"
      "libstilview"
    ];
  };
})
