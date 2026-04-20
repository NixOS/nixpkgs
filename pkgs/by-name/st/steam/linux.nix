{
  callPackage,
  lib,
  steam-unwrapped,
  writeShellScript,
  extraPkgs ? pkgs: [ ], # extra packages to add to targetPkgs
  extraLibraries ? pkgs: [ ], # extra packages to add to multiPkgs
  extraProfile ? "", # string to append to profile
  extraPreBwrapCmds ? "", # extra commands to run before calling bubblewrap
  extraBwrapArgs ? [ ], # extra arguments to pass to bubblewrap (real default is at usage site)
  extraArgs ? "", # arguments to always pass to steam
  extraEnv ? { }, # Environment variables to pass to Steam
  privateTmp ? true, # if the steam bubblewrap should isolate /tmp
}:
let
  buildRuntimeEnv = callPackage ./runtime-env.nix { };
in
buildRuntimeEnv {
  pname = "steam";
  inherit (steam-unwrapped) version meta;

  extraPkgs = pkgs: [ steam-unwrapped ] ++ extraPkgs pkgs;
  inherit
    extraLibraries
    extraProfile
    extraPreBwrapCmds
    extraBwrapArgs
    extraEnv
    privateTmp
    ;

  runScript = writeShellScript "steam-wrapped" ''
    exec steam ${extraArgs} "$@"
  '';

  extraInstallCommands = ''
    ln -s ${steam-unwrapped}/share $out/share
  '';

  passthru =
    let
      makeSteamRun =
        package:
        buildRuntimeEnv {
          inherit (steam-unwrapped) version;
          pname = "steam-run";

          extraPkgs = pkgs: package ++ extraPkgs pkgs;

          inherit
            extraLibraries
            extraProfile
            extraPreBwrapCmds
            extraBwrapArgs
            extraEnv
            privateTmp
            ;

          runScript = writeShellScript "steam-run" ''
            if [ $# -eq 0 ]; then
              echo "Usage: steam-run command-to-run args..." >&2
              exit 1
            fi

            exec "$@"
          '';

          meta = {
            description = "Run commands in the same FHS environment that is used for Steam";
            mainProgram = "steam-run";
            name = "steam-run";
            license = lib.licenses.mit;
          };
        };
    in
    {
      inherit buildRuntimeEnv;

      run = makeSteamRun [ steam-unwrapped ];
      run-free = makeSteamRun [ ];
    };
}
