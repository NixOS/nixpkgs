{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "attempto-clex";
  version = "5133afe";

  src = fetchFromGitHub {
    owner = "Attempto";
    repo = "Clex";
    rev = version;
    sha256 = "0p9s64g1jic213bwm6347jqckszgnni9szrrz31qjgaf32kf7nkp";
  };

  installPhase = ''
    mkdir -p $out
    cp clex_lexicon.pl $out
  '';

  meta = with lib; {
    description = "Large lexicon for APE (~100,000 entries)";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ yrashk ];
  };
}
