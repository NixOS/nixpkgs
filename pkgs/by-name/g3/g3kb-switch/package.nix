{
  lib,
  stdenv,
  cmake,
  pkg-config,
  glib,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "g3kb-switch";
  version = "1.4";
  src = fetchFromGitHub {
    owner = "lyokha";
    repo = "g3kb-switch";
    rev = version;
    sha256 = "sha256-mcZduHcteZ+nS0YEZG5DfmpA8xrnLhwxumq6hLuLPIs=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    glib
  ];

  meta = with lib; {
    homepage = "https://github.com/lyokha/g3kb-switch";
    description = "CLI keyboard layout switcher for GNOME Shell";
    mainProgram = "g3kb-switch";
    license = licenses.bsd2;
    maintainers = with maintainers; [ Freed-Wu ];
    platforms = platforms.unix;
  };
}
