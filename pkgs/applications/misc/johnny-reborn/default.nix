{ lib
, stdenv
, fetchFromGitHub
, SDL2
}:

stdenv.mkDerivation rec {
  pname = "johnny-reborn-engine";
  version = "0.34";

  src = fetchFromGitHub {
    owner = "xesf";
    repo = "jc_reborn";
    rev = "v${version}";
    hash = "sha256-JXaYSHpow7Pzy+ATEinET9ffvPIkOmlylnerZJnMUjY=";
  };

  buildInputs = [ SDL2 ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp jc_reborn $out/bin/

    runHook postInstall
  '';

  meta = {
    description = "An open-source engine for the classic \"Johnny Castaway\" screensaver (engine only)";
    homepage = "https://github.com/xesf/jc_reborn";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pedrohlc ];
    mainProgram = "jc_reborn";
    inherit (SDL2.meta) platforms;
  };
}
