{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "urxvt-perls-${version}";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "muennich";
    repo = "urxvt-perls";
    rev = version;
    sha256 = "1cb0jbjmwfy2dlq2ny8wpc04k79jp3pz9qhbmgagsxs3sp1jg2hz";
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
    platforms = with platforms; unix;
  };
}
