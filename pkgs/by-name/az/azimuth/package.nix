{
  lib,
  stdenv,
  fetchFromGitHub,
  libGL,
  SDL2,
  which,
  pkg-config,
  installTool ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "azimuth";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "mdsteele";
    repo = "azimuth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N5Ahetw/zOXDrEiR1umQNF6i3yeawavoLceiU+xD//g=";
  };

  postPatch = ''
    substituteInPlace Makefile --replace-fail "-Werror" ""
  '';

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    pkg-config
    which
  ];

  buildInputs = [
    libGL
    SDL2
  ];

  makeFlags = [
    "BUILDTYPE=release"
    "PREFIX=${placeholder "out"}"
    "INSTALLTOOL=${if installTool then "true" else "false"}"
  ];

  enableParallelBuilding = true;

  doCheck = true;
  checkTarget = "test";

  meta = {
    description = "Metroidvania game using only vectorial graphic";
    mainProgram = "azimuth";
    longDescription = ''
      Azimuth is a metroidvania game, and something of an homage to the previous
      greats of the genre (Super Metroid in particular). You will need to pilot
      your ship, explore the inside of the planet, fight enemies, overcome
      obstacles, and uncover the storyline piece by piece. Azimuth features a
      huge game world to explore, lots of little puzzles to solve, dozens of
      weapons and upgrades to find and use, and a wide variety of enemies and
      bosses to tangle with.
    '';

    license = lib.licenses.gpl3Plus;
    homepage = "https://mdsteele.games/azimuth/index.html";
    maintainers = with lib.maintainers; [ marius851000 ];
    platforms = lib.platforms.linux;
  };

})
