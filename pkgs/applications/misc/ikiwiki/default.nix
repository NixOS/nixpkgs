{ stdenv, fetchurl, perl, gettext, makeWrapper, lib, PerlMagick, YAML
, TextMarkdown, URI, HTMLParser, HTMLScrubber, HTMLTemplate, TimeDate
, CGISession, CGIFormBuilder, DBFile, LocaleGettext, RpcXML, XMLSimple
, gitSupport ? false
, git ? null
, monotoneSupport ? false
, monotone ? null
, extraUtils ? []
}:

assert gitSupport -> (git != null);
assert monotoneSupport -> (monotone != null);

let
  name = "ikiwiki";
  version = "3.20111229";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "http://ftp.de.debian.org/debian/pool/main/i/ikiwiki/${name}_${version}.tar.gz";
    sha256 = "6470d40c77ae055cfe8c5bbe2f64c765fc84f1ed2dcdd7dcc7577ae190414b89";
  };

  buildInputs = [ perl TextMarkdown URI HTMLParser HTMLScrubber HTMLTemplate
    TimeDate gettext makeWrapper DBFile CGISession CGIFormBuilder LocaleGettext
    RpcXML XMLSimple PerlMagick YAML]
    ++ stdenv.lib.optionals gitSupport [git]
    ++ stdenv.lib.optionals monotoneSupport [monotone];

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
    for a in "$out/bin/"*; do
      wrapProgram $a --suffix PERL5LIB : $PERL5LIB --prefix PATH : ${perl}/bin:$out/bin \
      ${lib.optionalString gitSupport
        ''--prefix PATH : ${git}/bin \''}
      ${lib.optionalString monotoneSupport
        ''--prefix PATH : ${monotone}/bin \''}
      ${lib.concatMapStrings (x: "--prefix PATH : ${x}/bin ") extraUtils}
    done
  '';

  meta = {
    description = "Wiki compiler, storing pages and history in a RCS";
    homepage = http://ikiwiki.info/;
    license = "GPLv2+";
  };
}
