{
  lib,
  steam,
  heroic-unwrapped,

  # Extra flags passed to Heroic/Electron, e.g. "--enable-features=VaapiVideoDecoder"
  commandLineArgs ? "",
  extraPkgs ? pkgs: [ ],
  extraLibraries ? pkgs: [ ],
  extraEnv ? { },
  extraProfile ? "",
  extraPreBwrapCmds ? "",
  extraBwrapArgs ? [ ],
}:

steam.buildRuntimeEnv {
  pname = "heroic";
  inherit (heroic-unwrapped) version meta;

  runScript = "heroic ${commandLineArgs}";

  extraPkgs =
    pkgs:
    [
      heroic-unwrapped
      pkgs.cabextract
      pkgs.curl
      pkgs.rsync
      pkgs.unzip
      # winetricks and heroic look for `7z`
      (pkgs.runCommand "7zz-compat" { } ''
        mkdir -p $out/bin
        ln -s ${lib.getExe pkgs._7zz} $out/bin/7z
        ln -s ${lib.getExe pkgs._7zz} $out/bin/7za
        ln -s ${lib.getExe pkgs._7zz} $out/bin/7zz
      '')
    ]
    ++ extraPkgs pkgs;

  inherit
    extraLibraries
    extraEnv
    extraProfile
    extraPreBwrapCmds
    extraBwrapArgs
    ;

  privateTmp = false;

  extraInstallCommands = ''
    mkdir -p $out/share
    ln -s ${heroic-unwrapped}/share/applications $out/share
    ln -s ${heroic-unwrapped}/share/icons $out/share
  '';
}
