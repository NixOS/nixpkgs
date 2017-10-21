{ stdenv, fetchFromGitHub, wmctrl }:

stdenv.mkDerivation {
  name = "urxvt-perl-2015-01-16";

  src = fetchFromGitHub {
    owner = "effigies";
    repo = "urxvt-perl";
    rev = "c3beb9ff09a7139591416c61f8e9458c8a23bea5";
    sha256 = "1w1p8ng7bwq5hnaprjl1zf073y5l3hdsj7sz7cll6isjswcm6r0s";
  };

  installPhase = ''
    substituteInPlace fullscreen \
      --replace "wmctrl" "${wmctrl}/bin/wmctrl"

    mkdir -p $out/lib/urxvt/perl
    cp fullscreen $out/lib/urxvt/perl
    cp newterm $out/lib/urxvt/perl
  '';

  meta = with stdenv.lib; {
    description = "Perl extensions for the rxvt-unicode terminal emulator";
    homepage = https://github.com/effigies/urxvt-perl;
    license = licenses.gpl3;
    maintainers = with maintainers; [ cstrahan ];
    platforms = with platforms; unix;
  };
}
