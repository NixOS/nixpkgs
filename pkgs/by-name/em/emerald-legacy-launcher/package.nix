{
  lib,
  steam,
  emerald-legacy-launcher-unwrapped,
  libarchive,
  python3,
  extraPkgs ? pkgs: [ ],
  extraLibraries ? pkgs: [ ],
  extraEnv ? { },
}:

steam.buildRuntimeEnv {
  pname = "emerald-legacy-launcher";
  inherit (emerald-legacy-launcher-unwrapped) version meta;

  runScript = lib.getExe emerald-legacy-launcher-unwrapped;

  extraPkgs =
    pkgs:
    [
      emerald-legacy-launcher-unwrapped
      libarchive
      python3
    ]
    ++ extraPkgs pkgs;

  inherit extraLibraries extraEnv;

  extraInstallCommands = ''
    mkdir -p $out/share
    ln -s ${emerald-legacy-launcher-unwrapped}/share/applications $out/share
    ln -s ${emerald-legacy-launcher-unwrapped}/share/icons $out/share
  '';

  privateTmp = false;
}
