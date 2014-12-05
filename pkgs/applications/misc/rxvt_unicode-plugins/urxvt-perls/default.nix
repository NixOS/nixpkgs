{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "urxvt-perls";

  src = fetchgit {
    url = "https://github.com/muennich/urxvt-perls";
    rev = "4dec629b3631297d17855c35be1b723e2d9e7591";
    sha256 = "c61bc8819b4e6655ed4a3ce3b347cb6dbebcb484d5d3973cbe9aa7f2c98d372f";
  };

  installPhase = ''
    mkdir -p $out/lib/urxvt/perl
    cp clipboard \
       keyboard-select \
       url-select \
    $out/lib/urxvt/perl
  '';

  meta = with stdenv.lib; {
    description = "Perl extensions for the rxvt-unicode terminal emulator";
    homepage = "https://github.com/muennich/urxvt-perls";
    license = licenses.gpl2;
    maintainers = maintainers.abbradar;
  };
}