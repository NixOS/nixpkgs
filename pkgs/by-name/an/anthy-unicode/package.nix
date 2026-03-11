{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPackages,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "anthy-unicode";
  version = "1.0.0.20260213";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "fujiwarat";
    repo = "anthy-unicode";
    tag = finalAttrs.version;
    sha256 = "sha256-lyd6cvuddQa535ZXhng6iQbP9cwfPXWXBEsqOEsjkHI=";
  };

  postPatch = lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    # for cross builds, copy build tools from the native package
    cp -r "${buildPackages.anthy-unicode.dev}"/lib/internals/{mkdepgraph,.libs} depgraph/
    cp -r "${buildPackages.anthy-unicode.dev}"/lib/internals/{mkworddic,.libs} mkworddic/
    cp -r "${buildPackages.anthy-unicode.dev}"/lib/internals/{calctrans,.libs} calctrans/
    cp -r "${buildPackages.anthy-unicode.dev}"/lib/internals/{mkfiledic,.libs} mkanthydic/
    substituteInPlace mkworddic/Makefile.in \
      --replace-fail 'anthy.wdic : mkworddic' 'anthy.wdic : ' \
      --replace-fail 'all: ' 'all: anthy.wdic #'
    substituteInPlace calctrans/Makefile.in \
      --replace-fail '$(dict_source_files): $(srcdir)/corpus_info $(srcdir)/weak_words calctrans' \
                     '$(dict_source_files): $(srcdir)/corpus_info $(srcdir)/weak_words' \
      --replace-fail 'all-am: Makefile $(PROGRAMS) $(DATA)' 'all-am: $(DATA)'
    substituteInPlace depgraph/Makefile.in \
      --replace-fail 'anthy.dep : mkdepgraph' 'anthy.dep : ' \
      --replace-fail 'all-am: Makefile $(PROGRAMS) $(DATA)' 'all-am: $(DATA)'
    substituteInPlace mkanthydic/Makefile.in \
      --replace-fail 'anthy.dic : mkfiledic' 'anthy.dic : ' \
      --replace-fail 'all-am: Makefile $(PROGRAMS) $(SCRIPTS) $(DATA)' 'all-am: $(DATA)'
  '';

  nativeBuildInputs = [ autoreconfHook ];

  postFixup = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    # not relevant for installed package
    mkdir "$dev/lib/internals"
    cp -r depgraph/{mkdepgraph,.libs} mkworddic/{mkworddic,.libs} calctrans/{calctrans,.libs} mkanthydic/{mkfiledic,.libs} "$dev/lib/internals"
  '';

  meta = {
    description = "Hiragana text to Kana Kanji mixed text Japanese input method (maintained fork)";
    homepage = "https://github.com/fujiwarat/anthy-unicode";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ sylfn ];
    platforms = lib.platforms.unix;
  };
})
