{
  buildEnv,
  callPackage,
  makeWrapper,
}:

let
  sp = callPackage ./sp.nix { };
  mp = sp.overrideAttrs (oldAttrs: {
    pname = "iortcw-mp";
    sourceRoot = "${oldAttrs.src.name}/MP";
  });
in
buildEnv {
  inherit (sp) version;
  pname = "iortcw";

  paths = [
    sp
    mp
  ];

  pathsToLink = [ "/opt" ];

  nativeBuildInputs = [ makeWrapper ];

  # so we can launch sp from mp game and vice versa
  postBuild = sp.postInstall;

  meta = sp.meta // {
    description = "Game engine for Return to Castle Wolfenstein";
  };
}
