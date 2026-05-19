{
  lib,
  stdenv,
  makeWrapper,
  fetchurl,
  fetchpatch,
  perl,
  gd,
  rrdtool,
}:

let
  perlWithPkgs = perl.withPackages (
    pp: with pp; [
      Socket6
      IOSocketINET6
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mrtg";
  version = "2.17.10";

  src = fetchurl {
    url = "https://oss.oetiker.ch/mrtg/pub/mrtg-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-x/EcteIXpQDYfuO10mxYqGUu28DTKRaIu3krAQ+uQ6w=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    # add support for ipv6 snmp:
    # https://github.com/oetiker/mrtg/blob/433ebfa5fc043971b46a5cd975fb642c76e3e49d/src/bin/mrtg#L331-L341
    perlWithPkgs
    gd
    rrdtool
  ];

  patches = [
    # gcc14 broke detection of printf format specifiers
    # building from master seems to be fixed upstream, so next release can (likely) drop the patch
    ./configure-long-long-format-gcc14.patch
    # fix gcc15 build, remove after next release
    (fetchpatch {
      name = "fix-gcc15.patch";
      url = "https://github.com/oetiker/mrtg/commit/a64a83210643114b3a892e70ce07ded5bd5de054.patch";
      hash = "sha256-9k16WrCAETuk5DJf5pmeXFHc4AZD9Acmtq/7P24tpwc=";
      excludes = [ "CHANGES" ];
      stripLen = 2;
      extraPrefix = "";
    })
  ];

  env.NIX_CFLAGS_LINK = "-lm";

  postInstall = ''
    # mrtg wants plain C locale
    wrapProgram $out/bin/mrtg  --set LANG C
  '';

  meta = {
    description = "Multi Router Traffic Grapher";
    homepage = "https://oss.oetiker.ch/mrtg/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      robberer
      usovalx
    ];
    platforms = lib.platforms.unix;
  };
})
