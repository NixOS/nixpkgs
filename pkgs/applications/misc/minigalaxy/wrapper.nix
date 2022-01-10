{ lib
, pkgs
, minigalaxy-unwrapped
, wine
, withWine ? true
}:

pkgs.symlinkJoin {
  name = "minigalaxy wrapper";
  paths = [
    minigalaxy-unwrapped
  ];
  buildInputs = [
    pkgs.makeWrapper
  ];
  postBuild = lib.optionalString withWine ''
    wrapProgram $out/bin/minigalaxy --prefix PATH : ${lib.makeBinPath [ wine ]}
  '';
}
