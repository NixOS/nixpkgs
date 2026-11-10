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
    hash = "sha256-4QJm4LpeugzeoxXLbAglhLT7nPGGZvNSg/AVkw53fHc=";
  };

  installPhase = ''
    mkdir -p $out/lib/urxvt/perl
    cp keyboard-select $out/lib/urxvt/perl
    cp deprecated/clipboard \
       deprecated/url-select \
    $out/lib/urxvt/perl
  '';

  meta = {
    description = "Perl extensions for the rxvt-unicode terminal emulator";
    homepage = "https://github.com/muennich/urxvt-perls";
    license = lib.licenses.gpl2;
    maintainers = [ ];
    platforms = with lib.platforms; unix;
  };
}
