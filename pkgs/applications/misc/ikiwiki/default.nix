{ lib, stdenv, fetchurl, perlPackages, gettext, makeWrapper, ImageMagick, which, highlight
, gitSupport ? false, git
, docutilsSupport ? false, python, docutils
, monotoneSupport ? false, monotone
, bazaarSupport ? false, breezy
, cvsSupport ? false, cvs, cvsps
, subversionSupport ? false, subversion
, mercurialSupport ? false, mercurial
, extraUtils ? []
}:

stdenv.mkDerivation rec {
  pname = "ikiwiki";
  version = "3.20200202.3";

  src = fetchurl {
    url = "mirror://debian/pool/main/i/ikiwiki/ikiwiki_${version}.orig.tar.xz";
    sha256 = "0skrc8r4wh4mjfgw1c94awr5sacfb9nfsbm4frikanc9xsy16ksr";
  };

  buildInputs = [ which highlight ]
    ++ (with perlPackages; [ perl TextMarkdown URI HTMLParser HTMLScrubber HTMLTemplate
      TimeDate gettext makeWrapper DBFile CGISession CGIFormBuilder LocaleGettext
      RpcXML XMLSimple ImageMagick YAML YAMLLibYAML HTMLTree AuthenPassphrase
      NetOpenIDConsumer LWPxParanoidAgent CryptSSLeay ])
    ++ lib.optionals docutilsSupport [python docutils]
    ++ lib.optionals gitSupport [git]
    ++ lib.optionals monotoneSupport [monotone]
    ++ lib.optionals bazaarSupport [breezy]
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
      ${lib.optionalString gitSupport "--prefix PATH : ${git}/bin "} \
      ${lib.optionalString monotoneSupport "--prefix PATH : ${monotone}/bin "} \
      ${lib.optionalString bazaarSupport "--prefix PATH : ${breezy}/bin "} \
      ${lib.optionalString cvsSupport "--prefix PATH : ${cvs}/bin "} \
      ${lib.optionalString cvsSupport "--prefix PATH : ${cvsps}/bin "} \
      ${lib.optionalString subversionSupport "--prefix PATH : ${subversion.out}/bin "} \
      ${lib.optionalString mercurialSupport "--prefix PATH : ${mercurial}/bin "} \
      ${lib.optionalString docutilsSupport ''--prefix PYTHONPATH : "$(toPythonPath ${docutils})" ''} \
      ${lib.concatMapStrings (x: "--prefix PATH : ${x}/bin ") extraUtils}
    done
  '';

  preCheck = ''
    # Git needs some help figuring this out during test suite run.
    export EMAIL="nobody@example.org"
  '';

  checkTarget = "test";
  doCheck = true;

  meta = with lib; {
    description = "Wiki compiler, storing pages and history in a RCS";
    homepage = "http://ikiwiki.info/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.peti ];
  };
}
