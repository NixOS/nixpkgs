{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rasm";
  version = "3.0.3";

  src = fetchFromGitHub {
    owner = "EdouardBERGE";
    repo = "rasm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-URCig2+Fxf0/skHsLb83Tv8JEjfIK5NNB1ZTrM9GqEI=";
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
})
