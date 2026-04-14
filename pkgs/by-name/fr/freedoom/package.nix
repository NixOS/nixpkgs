{
  asciidoc,
  asciidoctor,
  deutex,
  fetchFromGitHub,
  lib,
  nix-update-script,
  python3,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "freedoom";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "freedoom";
    repo = "freedoom";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uOLyh/epVxv3/N+6P1glBX1ZkGWzHWGaERYZRSL/3AU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    (python3.withPackages (ps: with ps; [ pillow ]))
    asciidoc
    asciidoctor
    deutex
  ];

  preBuild = ''
    patchShebangs .
  '';

  makeFlags = [ "prefix=$(out)" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Game based on the Doom engine";
    longDescription = ''
      Freedoom is a complete, free content first person shooter game,
      based on the Doom engine.

      Freedoom is not a program - rather, it consists of the levels,
      artwork, sound effects and music that make up the game.  To play
      Freedoom, [it must be paired with an
      engine](https://github.com/freedoom/freedoom#How-to-play) that
      can play it.
    '';
    homepage = "https://freedoom.github.io";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ yiyu ];
    platforms = lib.platforms.all;
  };
})
