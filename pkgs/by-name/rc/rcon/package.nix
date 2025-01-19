{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  glib,
  libbsd,
  check,
  pcre,
}:

stdenv.mkDerivation rec {
  pname = "rcon";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "n0la";
    repo = "rcon";
    rev = version;
    sha256 = "sha256-bHm6JeWmpg42VZQXikHl+BMx9zimRLBQWemTqOxyLhw=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    glib
    libbsd
    check
    pcre
  ];

  meta = {
    homepage = "https://github.com/n0la/rcon";
    description = "Source RCON client for command line";
    maintainers = with lib.maintainers; [ f4814n ];
    platforms = with lib.platforms; linux ++ darwin;
    license = lib.licenses.bsd2;
    mainProgram = "rcon";
  };
}
