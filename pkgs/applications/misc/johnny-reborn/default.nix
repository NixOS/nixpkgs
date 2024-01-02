{ lib
, stdenv
, fetchFromGitHub
, SDL2
}:

stdenv.mkDerivation {
  pname = "johnny-reborn-engine";
  version = "unstable-2020-12-06";

  src = fetchFromGitHub {
    owner = "jno6809";
    repo = "jc_reborn";
    rev = "524a5803e4fa65f840379c781f40ce39a927032e";
    hash = "sha256-YKAOCgdRnvNMzL6LJVXN0pLvjyJk4Zv/RCqGtDPFR90=";
  };

  makefile = "Makefile.linux";

  buildInputs = [ SDL2 ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp jc_reborn $out/

    runHook postInstall
  '';

  meta = {
    description = "An open-source engine for the classic \"Johnny Castaway\" screensaver (engine only)";
    homepage = "https://github.com/jno6809/jc_reborn";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pedrohlc ];
    inherit (SDL2.meta) platforms;
  };
}
