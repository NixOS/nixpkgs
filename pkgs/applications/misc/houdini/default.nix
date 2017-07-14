{ zsh, stdenv, callPackage, buildFHSUserEnv, undaemonize }:

let
  version = "16.0.633";
  houdini-runtime = callPackage ./runtime.nix { };
in buildFHSUserEnv rec {
  name = "houdini-${version}";

  extraBuildCommands = ''
    mkdir -p $out/usr/lib/sesi
  '';

  runScript = "${undaemonize}/bin/undaemonize ${houdini-runtime}/bin/houdini";
}

