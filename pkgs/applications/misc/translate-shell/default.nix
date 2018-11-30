{ stdenv, fetchFromGitHub, makeWrapper, curl, fribidi, rlwrap, gawk, groff, ncurses }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "translate-shell";
  version = "0.9.6.8";

  src = fetchFromGitHub {
    owner = "soimort";
    repo = "translate-shell";
    rev = "v${version}";
    sha256 = "17fc5nlc594lvmihx39h4ddmi8ja3qqsyswzxadbaz7l3zm356b8";
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
