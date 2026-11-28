{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkgs,
  perlPackages,
  imagemagickBig,
  gettext,
  makeWrapper,
  which,
  highlight,
  gitUpdater,
  gitSupport ? false,
  git,
  docutilsSupport ? false,
  python3,
  docutils,
  monotoneSupport ? false,
  monotone,
  bazaarSupport ? false,
  breezy,
  cvsSupport ? false,
  cvs,
  cvsps,
  subversionSupport ? false,
  subversion,
  mercurialSupport ? false,
  mercurial,
  extraUtils ? [ ],
}:

let
  # Build the Image::Magick perl module against imagemagickBig instead of the default imagemagick.
  ImageMagick =
    (perlPackages.override {
      pkgs = pkgs // {
        imagemagick = imagemagickBig;
      };
    }).ImageMagick;
in

stdenv.mkDerivation rec {
  pname = "ikiwiki";
  version = "3.20260201";

  src = fetchurl {
    url = "mirror://debian/pool/main/i/ikiwiki/ikiwiki_${version}.orig.tar.xz";
    sha256 = "SU+LBc8uJNuN4BsaACNL2U7C7LOEIhMH2R7f1Jjp8I4=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    which
    highlight
  ]
  ++ (with perlPackages; [
    perl
    TextMarkdown
    URI
    HTMLParser
    HTMLScrubber
    HTMLTemplate
    TimeDate
    gettext
    DBFile
    CGISession
    CGIFormBuilder
    LocaleGettext
    RpcXML
    XMLSimple
    ImageMagick
    YAML
    YAMLLibYAML
    HTMLTree
    AuthenPassphrase
    NetOpenIDConsumer
    LWPxParanoidAgent
    CryptSSLeay
  ])
  ++ lib.optionals docutilsSupport [
    (python3.withPackages (pp: with pp; [ pygments ]))
    docutils
  ]
  ++ lib.optionals gitSupport [ git ]
  ++ lib.optionals monotoneSupport [ monotone ]
  ++ lib.optionals bazaarSupport [ breezy ]
  ++ lib.optionals cvsSupport [
    cvs
    cvsps
    perlPackages.Filechdir
  ]
  ++ lib.optionals subversionSupport [ subversion ]
  ++ lib.optionals mercurialSupport [ mercurial ];

  patches = [
    # A few markdown tests fail, but this is expected when using Text::Markdown
    # instead of Text::Markdown::Discount.
    ./remove-markdown-tests.patch
  ];

  postPatch = ''
    sed -i s@/usr/bin/perl@${perlPackages.perl}/bin/perl@ pm_filter mdwn2man
    sed -i s@/etc/ikiwiki@$out/etc@ Makefile.PL
    sed -i /ENV{PATH}/d ikiwiki.in
    # State the gcc dependency, and make the cgi use our wrapper
    sed -i -e 's@$0@"'$out/bin/ikiwiki'"@' \
        -e "s@'cc'@'${stdenv.cc}/bin/gcc'@" IkiWiki/Wrapper.pm
    # Without patched plugin shebangs, some tests like t/rst.t fail
    # (with docutilsSupport enabled)
    patchShebangs plugins/*

    # Creating shared git repo fails when running tests in Nix sandbox.
    # The error is: "fatal: Could not make /tmp/ikiwiki-test-git.2043/repo/branches/ writable by group".
    # Hopefully, not many people use `ikiwiki-makerepo` to create locally shared repositories these days.
    substituteInPlace ikiwiki-makerepo --replace "git --bare init --shared" "git --bare init"
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

  passthru.updateScript = gitUpdater {
    # No nicer place to find latest release.
    url = "git://git.ikiwiki.info/";
    allowedVersions = "^[0-9]";
  };

  meta = {
    description = "Wiki compiler, storing pages and history in a RCS";
    homepage = "http://ikiwiki.info/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.wentasah ];
  };
}
