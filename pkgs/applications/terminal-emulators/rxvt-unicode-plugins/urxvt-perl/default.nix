{
  lib,
  stdenv,
  fetchFromGitHub,
  wmctrl,
}:

stdenv.mkDerivation {
  pname = "urxvt-perl";
  version = "unstable-2015-01-16";

  src = fetchFromGitHub {
    owner = "effigies";
    repo = "urxvt-perl";
    rev = "c3beb9ff09a7139591416c61f8e9458c8a23bea5";
    hash = "sha256-GmRTGddSR0MpO18fqRsctPhxgPuBynyVhQXzdZ5FN/A=";
  };

  installPhase = ''
    substituteInPlace fullscreen \
      --replace "wmctrl" "${wmctrl}/bin/wmctrl"

    mkdir -p $out/lib/urxvt/perl
    cp fullscreen $out/lib/urxvt/perl
    cp newterm $out/lib/urxvt/perl
  '';

  meta = {
    description = "Perl extensions for the rxvt-unicode terminal emulator";
    homepage = "https://github.com/effigies/urxvt-perl";
    license = lib.licenses.gpl3;
    maintainers = [ ];
    platforms = with lib.platforms; unix;
  };
}
