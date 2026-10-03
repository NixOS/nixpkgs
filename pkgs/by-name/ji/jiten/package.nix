{
  lib,
  fetchFromGitHub,
  python3,
  bash,
  makeWrapper,
  kanjidraw,
  installShellFiles,
  pcre,
  sqlite,
  nodejs,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "jiten";
  version = "1.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "obfusk";
    repo = "jiten";
    rev = "v${version}";
    hash = "sha256-N2Ngs9nAv1A+KeR+/0vdPWCTgZsF3w1bhytHbUbobY0=";
  };

  nonFreeData = fetchFromGitHub {
    owner = "obfusk";
    repo = "jiten-nonfree-data";
    rev = "v${version}";
    hash = "sha256-YZX7XBOhU+o92CqSntCR3eQvqMekMxmn8e8drkFEX5s=";
  };

  patches = [
    # Potentially can be dropped after the next release
    # https://github.com/NixOS/nixpkgs/issues/271600
    ./cookie-fix.patch
  ];

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];
  buildInputs = [
    pcre
    sqlite
  ];
  propagatedBuildInputs = with python3.pkgs; [
    click
    flask
    kanjidraw
  ];
  nativeCheckInputs = [ nodejs ];

  preBuild = ''
    export JITEN_VERSION=${version}   # override `git describe`
    export JITEN_FINAL=yes            # build & package *.sqlite3
  '';

  postPatch = ''
    rmdir nonfree-data
    ln -s ${nonFreeData} nonfree-data
    substituteInPlace Makefile --replace /bin/bash ${bash}/bin/bash
    substituteInPlace jiten/res/jmdict/Makefile \
      --replace /bin/bash ${bash}/bin/bash
  '';

  checkPhase = ''
    make test
  '';

  postInstall = ''
    # requires pywebview
    rm $out/bin/jiten-gui

    installShellCompletion --cmd jiten \
      --bash <(_JITEN_COMPLETE=bash_source $out/bin/jiten) \
      --zsh <(_JITEN_COMPLETE=zsh_source $out/bin/jiten) \
      --fish <(env _JITEN_COMPLETE=fish_source $out/bin/jiten)
  '';

  meta = {
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
      • handwritten kanji recognition
      • browse by frequency/level/jlpt/SKIP

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
    license = with lib.licenses; [
      agpl3Plus # code
      cc-by-sa-30 # jmdict/kanjidic
      unfreeRedistributable # pitch data & audio are non-commercial
    ];
    maintainers = [ lib.maintainers.obfusk ];
  };
}
