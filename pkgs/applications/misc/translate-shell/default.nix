{ lib, stdenv, fetchFromGitHub, makeWrapper, curl, fribidi, rlwrap, gawk, groff, ncurses, hexdump }:

stdenv.mkDerivation rec {
  pname = "translate-shell";
  version = "0.9.7.1";

  src = fetchFromGitHub {
    owner = "soimort";
    repo = "translate-shell";
    rev = "v${version}";
    sha256 = "sha256-ILXE8cSrivYqMruE+xtNIInLdwdRfMX5dneY9Nn12Uk=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    wrapProgram $out/bin/trans \
      --prefix PATH : ${lib.makeBinPath [
        gawk
        curl
        ncurses
        rlwrap
        groff
        fribidi
        hexdump
      ]}
  '';

  meta = with lib; {
    homepage = "https://www.soimort.org/translate-shell";
    description = "Command-line translator using Google Translate, Bing Translator, Yandex.Translate, and Apertium";
    license = licenses.unlicense;
    maintainers = with maintainers; [ ebzzry infinisil ];
    mainProgram = "trans";
    platforms = platforms.unix;
  };
}
