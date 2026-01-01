{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  version = "20250128";
  pname = "m4ri";

  src = fetchFromGitHub {
    owner = "malb";
    repo = "m4ri";
    rev = version;
    hash = "sha256-YoCTI4dLy95xuRJyNugIzGxE40B9pCWxRQtsyS/1Pds=";
  };

  doCheck = true;

  nativeBuildInputs = [
    autoreconfHook
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://malb.bitbucket.io/m4ri/";
    description = "Library to do fast arithmetic with dense matrices over F_2";
    license = lib.licenses.gpl2Plus;
    teams = [ lib.teams.sage ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    homepage = "https://malb.bitbucket.io/m4ri/";
    description = "Library to do fast arithmetic with dense matrices over F_2";
    license = licenses.gpl2Plus;
    teams = [ teams.sage ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
