{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "urxvt-autocomplete-all-the-things";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "Vifon";
    repo = "autocomplete-ALL-the-things";
    rev = version;
    hash = "sha256-WR+9pd1bDBdexhSA0ck+Ex1whR2pToI5fTm1Z1gqrRs=";
  };

  installPhase = ''
    mkdir -p $out/lib/urxvt/perl
    cp autocomplete-ALL-the-things $out/lib/urxvt/perl
  '';

  meta = {
    description = "urxvt plugin allowing user to easily complete arbitrary text";
    homepage = "https://github.com/Vifon/autocomplete-ALL-the-things";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ nickhu ];
    platforms = with lib.platforms; unix;
  };
}
