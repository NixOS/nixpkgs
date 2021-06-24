{ lib
, fetchFromGitHub
, python3Packages
, makeWrapper
, pcre
, sqlite
, nodejs
}:

python3Packages.buildPythonApplication rec {
  pname = "jiten";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "obfusk";
    repo = "jiten";
    rev = "v${version}";
    sha256 = "1lg1n7f4383jdlkbma0q65yl6l159wgh886admcq7l7ap26zpqd2";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ pcre sqlite ];
  propagatedBuildInputs = with python3Packages; [ click flask ];
  checkInputs = [ nodejs ];

  preBuild = ''
    export JITEN_VERSION=${version}   # override `git describe`
    export JITEN_FINAL=yes            # build & package *.sqlite3
  '';

  postPatch = ''
    substituteInPlace Makefile                  --replace /bin/bash "$(command -v bash)"
    substituteInPlace jiten/res/jmdict/Makefile --replace /bin/bash "$(command -v bash)"
  '';

  checkPhase = "make test";

  postInstall = ''
    # requires pywebview
    rm $out/bin/jiten-gui
  '';

  meta = with lib; {
    description = "Japanese android/cli/web dictionary based on jmdict/kanjidic";
    longDescription = ''
      Jiten is a Japanese dictionary based on JMDict/Kanjidic

      Fine-grained search using regexes (regular expressions)
      • simple searches don't require knowledge of regexes
      • quick reference available in the web interface and android app

      JMDict multilingual japanese dictionary
      • kanji, readings (romaji optional), meanings & more
      • meanings in english, dutch, german, french and/or spanish
      • pitch accent (from Wadoku)
      • browse by frequency/jlpt

      Kanji dictionary
      • readings (romaji optional), meanings (english), jmdict entries, radicals & more
      • search using SKIP codes
      • search by radical
      • browse by frequency/level/jlpt

      Example sentences (from Tatoeba)
      • with english, dutch, german, french and/or spanish translation
      • some with audio

      Stroke order
      • input a word or sentence and see how it's written

      Web interface
      • available online at https://jiten.obfusk.dev
      • light/dark mode
      • search history (stored locally)
      • tooltips to quickly see meanings and readings for kanji and words
      • use long press for tooltips on mobile
      • converts romaji to hiragana and between hiragana and katakana
      • can be run on your own computer

      Command-line interface
    '';
    homepage = "https://github.com/obfusk/jiten";
    license = with licenses; [
      agpl3Plus               # code
      cc-by-sa-30             # jmdict/kanjidic
      unfreeRedistributable   # pitch data from wadoku is non-commercial :(
    ];
    maintainers = [ maintainers.obfusk ];
    platforms = platforms.unix;
  };
}
