{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "urxvt-perls";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "muennich";
    repo = "urxvt-perls";
    rev = version;
    sha256 = "0xvwfw7965ghhd9g6rl6y6fgpd444l46rjqmlgg0rfjypbh6c0p1";
  };

  installPhase = ''
    mkdir -p $out/lib/urxvt/perl
    cp keyboard-select $out/lib/urxvt/perl
    cp deprecated/clipboard \
       deprecated/url-select \
    $out/lib/urxvt/perl
  '';

  meta = with lib; {
    description = "Perl extensions for the rxvt-unicode terminal emulator";
    homepage = "https://github.com/muennich/urxvt-perls";
    license = licenses.gpl2;
    maintainers = with maintainers; [ abbradar ];
    platforms = with platforms; unix;
  };
}
