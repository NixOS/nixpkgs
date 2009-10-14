{stdenv, fetchurl, perl, gettext, makeWrapper,
TextMarkdown, URI, HTMLParser, HTMLScrubber, HTMLTemplate, TimeDate}:

stdenv.mkDerivation {
  name = "ikiwiki_3.20091009";

  src = fetchurl {
    url = http://ftp.de.debian.org/debian/pool/main/i/ikiwiki/ikiwiki_3.20091009.tar.gz;
    sha256 = "1iznyiypsnhga71s31782j3rf52fyvxrcys3nfpcr8yg1a5zadpn";
  };

  buildInputs = [ perl TextMarkdown URI HTMLParser HTMLScrubber HTMLTemplate
    TimeDate gettext makeWrapper ];

  patchPhase = ''
    sed -i s@/usr/bin/perl@${perl}/bin/perl@ pm_filter mdwn2man
    sed -i s@/etc/ikiwiki@$out/etc@ Makefile.PL
    sed -i /ENV{PATH}/d ikiwiki.in
  '';

  configurePhase = "perl Makefile.PL PREFIX=$out";

  postInstall = ''
    for a in $out/bin/*; do
      wrapProgram $a --suffix PERL5LIB : $PERL5LIB --prefix PATH : ${perl}/bin:$out/bin
    done
  '';

  meta = { 
    description = "Wiki compiler, storing pages and history in a RCS";
    homepage = http://ikiwiki.info/;
    license = "GPLv2+";
  };
}
