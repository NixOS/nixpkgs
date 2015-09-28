{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "urxvt-perls-2015-03-28";

  src = fetchgit {
    url = "git://github.com/muennich/urxvt-perls";
    rev = "e4dbde31edd19e2f4c2b6c91117ee91e2f83ddd7";
    sha256 = "1f8a27c3d54377fdd4ab0be2f4efb8329d4900bb1c792b306dc23b5ee59260b1";
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
    maintainers = with maintainers; [ abbradar ];
  };
}
