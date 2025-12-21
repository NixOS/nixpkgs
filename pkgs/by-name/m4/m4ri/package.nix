{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  version = "20251207";
  pname = "m4ri";

  src = fetchFromGitHub {
    owner = "malb";
    repo = "m4ri";
    rev = version;
    hash = "sha256-8cO4mPPZj/QUnSJmsqTFQ+THdrnZnCa6wFACKOk78UQ=";
  };

  doCheck = true;

  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = {
    homepage = "https://malb.bitbucket.io/m4ri/";
    description = "Library to do fast arithmetic with dense matrices over F_2";
    license = lib.licenses.gpl2Plus;
    teams = [ lib.teams.sage ];
    platforms = lib.platforms.unix;
  };
}
