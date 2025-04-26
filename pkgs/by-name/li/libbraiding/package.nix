{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation rec {
  version = "1.3.1";
  pname = "libbraiding";

  src = fetchFromGitHub {
    owner = "miguelmarco";
    repo = "libbraiding";
    # version 1.3.1 contains a typo in configure.ac, fixed in the next commit.
    # TODO: remove if on upgrade
    rev = if version == "1.3.1" then "b174832026c2412baec83277c461e4df71d8525c" else version;
    hash = "sha256-ar/EiaMZuQRa1lr0sZPLRuk5K00j63TqNf0q0iuiKjw=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  # no tests included for now (2018-08-05), but can't hurt to activate
  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/miguelmarco/libbraiding/";
    description = "C++ library for computations on braid groups";
    longDescription = ''
      A library to compute several properties of braids, including centralizer and conjugacy check.
    '';
    license = licenses.gpl3;
    teams = [ teams.sage ];
    platforms = platforms.all;
  };
}
