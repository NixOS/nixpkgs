{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  perl,
  perlPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dnsenum";
  version = "1.2.4.2";

  src = fetchFromGitHub {
    owner = "fwaeytens";
    repo = "dnsenum";
    rev = finalAttrs.version;
    sha256 = "1bg1ljv6klic13wq4r53bg6inhc74kqwm3w210865b1v1n8wj60v";
  };

  propagatedBuildInputs = with perlPackages; [
    perl
    NetDNS
    NetIP
    NetNetmask
    StringRandom
    XMLWriter
    NetWhoisIP
    WWWMechanize
  ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -vD dnsenum.pl $out/bin/dnsenum
    install -vD dns.txt -t $out/share
  '';

  meta = {
    homepage = "https://github.com/fwaeytens/dnsenum";
    description = "Tool to enumerate DNS information";
    mainProgram = "dnsenum";
    maintainers = with lib.maintainers; [ c0bw3b ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
  };
})
