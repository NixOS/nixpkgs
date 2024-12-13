{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "rasm";
  version = "2.2.11";

  src = fetchFromGitHub {
    owner = "EdouardBERGE";
    repo = "rasm";
    rev = "v${version}";
    hash = "sha256-wFdRMWnOZ3gVp9RwTwD1bJEKVJ9khPRSQoCi75/YiPM=";
  };

  # by default the EXEC variable contains `rasm.exe`
  makeFlags = [ "EXEC=rasm" ];

  installPhase = ''
    install -Dt $out/bin rasm
  '';

  meta = {
    homepage = "http://rasm.wikidot.com/english-index:home";
    description = "Z80 assembler";
    mainProgram = "rasm";
    # use -n option to display all licenses
    license = lib.licenses.mit; # expat version
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = lib.platforms.all;
  };
}
