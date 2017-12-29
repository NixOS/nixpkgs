{ zsh, stdenv, callPackage, buildFHSUserEnv, undaemonize }:

let
  houdini-runtime = callPackage ./runtime.nix { };
in buildFHSUserEnv rec {
  name = "houdini-${houdini-runtime.version}";

  extraBuildCommands = ''
    mkdir -p $out/usr/lib/sesi
  '';

  runScript = "${undaemonize}/bin/undaemonize ${houdini-runtime}/bin/houdini";
}

