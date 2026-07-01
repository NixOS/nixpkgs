{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation rec {
  version = "1.3.2";
  pname = "libbraiding";

  src = fetchFromGitHub {
    owner = "miguelmarco";
    repo = "libbraiding";
    rev = version;
    hash = "sha256-Vo4nwzChjrI4PeNB+adPwDeL3gb++DEc4isX4/iDHMc=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  # no tests included for now (2018-08-05), but can't hurt to activate
  doCheck = true;

  meta = {
    homepage = "https://github.com/miguelmarco/libbraiding/";
    description = "C++ library for computations on braid groups";
    longDescription = ''
      A library to compute several properties of braids, including centralizer and conjugacy check.
    '';
    license = lib.licenses.gpl3;
    teams = [ lib.teams.sage ];
    platforms = lib.platforms.all;
  };
}
