{
  steam,
  heroic-unwrapped,
  extraPkgs ? pkgs: [ ],
  extraLibraries ? pkgs: [ ],
}:

steam.buildRuntimeEnv {
  pname = "heroic";
  inherit (heroic-unwrapped) version meta;

  runScript = "heroic";

  extraPkgs = pkgs: [ heroic-unwrapped ] ++ extraPkgs pkgs;
  inherit extraLibraries;

  extraInstallCommands = ''
    mkdir -p $out/share
    ln -s ${heroic-unwrapped}/share/applications $out/share
    ln -s ${heroic-unwrapped}/share/icons $out/share
  '';

  privateTmp = false;
}
