{stdenv, fetchurl, perl, gettext, makeWrapper, lib,
  TextMarkdown, URI, HTMLParser, HTMLScrubber, HTMLTemplate, TimeDate,
  CGISession, CGIFormBuilder, DBFile
  , git ? null
  , monotone ? null
  }:

stdenv.mkDerivation {
  name = "ikiwiki_3.20091009";

  src = fetchurl {
    url = http://ftp.de.debian.org/debian/pool/main/i/ikiwiki/ikiwiki_3.20091009.tar.gz;
    sha256 = "1iznyiypsnhga71s31782j3rf52fyvxrcys3nfpcr8yg1a5zadpn";
  };

  buildInputs = [ perl TextMarkdown URI HTMLParser HTMLScrubber HTMLTemplate
    TimeDate gettext makeWrapper DBFile CGISession CGIFormBuilder ]
    ++
    (lib.optional (monotone != null) monotone)
    ;

  patchPhase = ''
    sed -i s@/usr/bin/perl@${perl}/bin/perl@ pm_filter mdwn2man
    sed -i s@/etc/ikiwiki@$out/etc@ Makefile.PL
    sed -i /ENV{PATH}/d ikiwiki.in
    # State the gcc dependency, and make the cgi use our wrapper
    sed -i -e 's@$0@"'$out/bin/ikiwiki'"@' \
        -e "s@'cc'@'${stdenv.gcc}/bin/gcc'@" IkiWiki/Wrapper.pm
  '';

  configurePhase = "perl Makefile.PL PREFIX=$out";

  postInstall = ''
    for a in $out/bin/*; do
      wrapProgram $a --suffix PERL5LIB : $PERL5LIB --prefix PATH : ${perl}/bin:$out/bin \
      ${lib.optionalString (git != null) 
        ''--prefix PATH : ${git}/bin \''}
      ${lib.optionalString (monotone != null) 
        ''--prefix PATH : ${monotone}/bin \''}

    done
  '';

  meta = { 
    description = "Wiki compiler, storing pages and history in a RCS";
    homepage = http://ikiwiki.info/;
    license = "GPLv2+";
  };
}
