{
  lib,
  stdenv,
  makeWrapper,
  fetchurl,
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
stdenv.mkDerivation rec {
  pname = "mrtg";
  version = "2.17.10";

  src = fetchurl {
    url = "https://oss.oetiker.ch/mrtg/pub/mrtg-${version}.tar.gz";
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
    # just keep the CFLAGS below
    ./configure-long-long-format-gcc14.patch
  ];
  env.NIX_CFLAGS_COMPILE = "-Werror";
  env.NIX_CFLAGS_LINK = "-lm";

  postInstall = ''
    # mrtg wants plain C locale
    wrapProgram $out/bin/mrtg  --set LANG C
  '';

  meta = with lib; {
    description = "Multi Router Traffic Grapher";
    homepage = "https://oss.oetiker.ch/mrtg/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [
      robberer
      usovalx
    ];
    platforms = platforms.unix;
  };
}
