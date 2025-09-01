{
  lib,
  stdenv,
  fetchurl,
  buildPackages,
}:

stdenv.mkDerivation rec {
  pname = "anthy";
  version = "9100h";

  postPatch = lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    # for cross builds, copy build tools from the native package
    cp -r "${buildPackages.anthy.dev}"/lib/internals/{mkdepgraph,.libs} depgraph/
    cp -r "${buildPackages.anthy.dev}"/lib/internals/{mkworddic,.libs} mkworddic/
    cp -r "${buildPackages.anthy.dev}"/lib/internals/{calctrans,.libs} calctrans/
    cp -r "${buildPackages.anthy.dev}"/lib/internals/{mkfiledic,.libs} mkanthydic/
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

  outputs = [
    "out"
    "dev"
  ];

  meta = with lib; {
    description = "Hiragana text to Kana Kanji mixed text Japanese input method";
    homepage = "https://anthy.osdn.jp/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };

  postFixup = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    # not relevant for installed package
    mkdir "$dev/lib/internals"
    cp -r depgraph/{mkdepgraph,.libs} mkworddic/{mkworddic,.libs} calctrans/{calctrans,.libs} mkanthydic/{mkfiledic,.libs} "$dev/lib/internals"
  '';

  src = fetchurl {
    url = "mirror://osdn/anthy/37536/anthy-${version}.tar.gz";
    sha256 = "0ism4zibcsa5nl77wwi12vdsfjys3waxcphn1p5s7d0qy1sz0mnj";
  };
}
