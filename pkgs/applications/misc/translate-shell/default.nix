{ stdenv, fetchFromGitHub, makeWrapper, curl, fribidi, rlwrap, gawk, groff, ncurses }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "translate-shell";
  version = "0.9.6.7";

  src = fetchFromGitHub {
    owner = "soimort";
    repo = "translate-shell";
    rev = "v${version}";
    sha256 = "0krcidjh32xwybr1v4nykgf0jjnffjqx125bvn3jh2a44cikyq3n";
  };

  buildInputs = [ makeWrapper ];

  installFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/trans \
      --prefix PATH : ${stdenv.lib.makeBinPath [
        gawk
        curl
        ncurses
        rlwrap
        groff
        fribidi
      ]}
  '';

  meta = with stdenv.lib; {
    homepage = https://www.soimort.org/translate-shell;
    description = "Command-line translator using Google Translate, Bing Translator, Yandex.Translate, and Apertium";
    license = licenses.unlicense;
    maintainers = with maintainers; [ ebzzry infinisil ];
    platforms = platforms.unix;
  };
}
