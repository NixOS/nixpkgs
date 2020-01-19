{ stdenv, fetchurl, perlPackages, gettext, makeWrapper, PerlMagick, which
, gitSupport ? false, git ? null
, docutilsSupport ? false, python ? null, docutils ? null
, monotoneSupport ? false, monotone ? null
, bazaarSupport ? false, bazaar ? null
, cvsSupport ? false, cvs ? null, cvsps ? null
, subversionSupport ? false, subversion ? null
, mercurialSupport ? false, mercurial ? null
, extraUtils ? []
}:

assert docutilsSupport -> (python != null && docutils != null);
assert gitSupport -> (git != null);
assert monotoneSupport -> (monotone != null);
assert bazaarSupport -> (bazaar != null);
assert cvsSupport -> (cvs != null && cvsps != null && perlPackages.Filechdir != null);
assert subversionSupport -> (subversion != null);
assert mercurialSupport -> (mercurial != null);

let
  name = "ikiwiki";
  version = "3.20190228";

  lib = stdenv.lib;
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://debian/pool/main/i/ikiwiki/${name}_${version}.orig.tar.xz";
    sha256 = "17pyblaqhkb61lxl63bzndiffism8k859p54k3k4sghclq6lsynh";
  };

  buildInputs = [ which ]
    ++ (with perlPackages; [ perl TextMarkdown URI HTMLParser HTMLScrubber HTMLTemplate
          TimeDate gettext makeWrapper DBFile CGISession CGIFormBuilder LocaleGettext
          RpcXML XMLSimple PerlMagick YAML YAMLLibYAML HTMLTree AuthenPassphrase
          NetOpenIDConsumer LWPxParanoidAgent CryptSSLeay ])
    ++ lib.optionals docutilsSupport [python docutils]
    ++ lib.optionals gitSupport [git]
    ++ lib.optionals monotoneSupport [monotone]
    ++ lib.optionals bazaarSupport [bazaar]
    ++ lib.optionals cvsSupport [cvs cvsps perlPackages.Filechdir]
    ++ lib.optionals subversionSupport [subversion]
    ++ lib.optionals mercurialSupport [mercurial];

  # A few markdown tests fail, but this is expected when using Text::Markdown
  # instead of Text::Markdown::Discount.
  patches = [ ./remove-markdown-tests.patch ];

  postPatch = ''
    sed -i s@/usr/bin/perl@${perlPackages.perl}/bin/perl@ pm_filter mdwn2man
    sed -i s@/etc/ikiwiki@$out/etc@ Makefile.PL
    sed -i /ENV{PATH}/d ikiwiki.in
    # State the gcc dependency, and make the cgi use our wrapper
    sed -i -e 's@$0@"'$out/bin/ikiwiki'"@' \
        -e "s@'cc'@'${stdenv.cc}/bin/gcc'@" IkiWiki/Wrapper.pm
  '';

  configurePhase = "perl Makefile.PL PREFIX=$out";

  postInstall = ''
    for a in "$out/bin/"*; do
      wrapProgram $a --suffix PERL5LIB : $PERL5LIB --prefix PATH : ${perlPackages.perl}/bin:$out/bin \
      ${lib.optionalString gitSupport ''--prefix PATH : ${git}/bin \''}
      ${lib.optionalString monotoneSupport ''--prefix PATH : ${monotone}/bin \''}
      ${lib.optionalString bazaarSupport ''--prefix PATH : ${bazaar}/bin \''}
      ${lib.optionalString cvsSupport ''--prefix PATH : ${cvs}/bin \''}
      ${lib.optionalString cvsSupport ''--prefix PATH : ${cvsps}/bin \''}
      ${lib.optionalString subversionSupport ''--prefix PATH : ${subversion.out}/bin \''}
      ${lib.optionalString mercurialSupport ''--prefix PATH : ${mercurial}/bin \''}
      ${lib.concatMapStrings (x: "--prefix PATH : ${x}/bin ") extraUtils}
    done
  '';

  preCheck = ''
    # Git needs some help figuring this out during test suite run.
    export EMAIL="nobody@example.org"
  '';

  checkTarget = "test";
  doCheck = true;

  meta = {
    description = "Wiki compiler, storing pages and history in a RCS";
    homepage = http://ikiwiki.info/;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.peti ];
  };
}
