{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  csdr,
}:

stdenv.mkDerivation rec {
  pname = "csdreit";
  version = "0.0.11-unstable";

  src = fetchFromGitHub {
    owner = "luarvique";
    repo = "csdr-eti";
    rev = "a52651366276c382fbe87131d44c37642de65e7f";
    hash = "sha256-AozYR19jr6v2V3UPZ4U+cXdU7uVN/lvWYicz0lA3mpY=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  propagatedBuildInputs = [
    csdr
  ];

  hardeningDisable = lib.optional stdenv.hostPlatform.isAarch64 "format";

  meta = with lib; {
    homepage = "https://github.com/luarvique/csdr-eti";
    description = "A simple DSP library and command-line tool for Software Defined Radio";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = [ maintainers.mafo ];
    teams = [ teams.c3d2 ];
  };
}
