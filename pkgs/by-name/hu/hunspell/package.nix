{
  lib,
  stdenv,
  autoreconfHook,
  callPackage,
  fetchFromGitHub,
  hunspellDicts,
  ncurses,
  nix-update-script,
  readline,
  testers,
  validatePkgConfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hunspell";
  version = "1.7.2";

  outputs = [
    "bin"
    "dev"
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "hunspell";
    repo = "hunspell";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-x2FXxnVIqsf5/UEQcvchAndXBv/3mW8Z55djQAFgNA8=";
  };

  patches = [ ./0001-Make-hunspell-look-in-XDG_DATA_DIRS-for-dictionaries.patch ];

  postPatch = ''
    patchShebangs tests
  '';

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    validatePkgConfig
  ];

  buildInputs = [
    ncurses
    readline
  ];

  autoreconfFlags = [ "-vfi" ];

  configureFlags = [
    "--with-ui"
    "--with-readline"
  ];

  hardeningDisable = [ "format" ];

  passthru = {
    withDicts = callPackage ./wrapper.nix { hunspell = finalAttrs.finalPackage; };
    tests = {
      pkg-config = testers.hasPkgConfigModules { package = finalAttrs.finalPackage; };
      version = testers.testVersion { package = finalAttrs.finalPackage; };
      wrapper = finalAttrs.finalPackage.withDicts (d: [ d.en_US ]);
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Spell checker";
    longDescription = ''
      Hunspell is the spell checker of LibreOffice, OpenOffice.org, Mozilla
      Firefox 3 & Thunderbird, Google Chrome, and it is also used by
      proprietary software packages, like macOS, InDesign, memoQ, Opera and
      SDL Trados.

      Main features:

      * Extended support for language peculiarities; Unicode character encoding, compounding and complex morphology.
      * Improved suggestion using n-gram similarity, rule and dictionary based pronunciation data.
      * Morphological analysis, stemming and generation.
      * Hunspell is based on MySpell and works also with MySpell dictionaries.
      * C++ library under GPL/LGPL/MPL tri-license.
      * Interfaces and ports:
        * Enchant (Generic spelling library from the Abiword project),
        * XSpell (macOS port, but Hunspell is part of the macOS from version 10.6 (Snow Leopard), and
            now it is enough to place Hunspell dictionary files into
            ~/Library/Spelling or /Library/Spelling for spell checking),
        * Delphi, Java (JNA, JNI), Perl, .NET, Python, Ruby ([1], [2]), UNO.
    '';
    homepage = "http://hunspell.github.io/";
    changelog = "https://github.com/hunspell/hunspell/releases/tag/${finalAttrs.src.rev}";
    license = with lib.licenses; [
      gpl2Plus
      lgpl21Plus
      mpl11
    ];
    maintainers = with lib.maintainers; [
      getchoo
      RossSmyth
    ];
    mainProgram = "hunspell";
    platforms = lib.platforms.all;
    pkgConfigModules = [ "hunspell" ];
  };
})
