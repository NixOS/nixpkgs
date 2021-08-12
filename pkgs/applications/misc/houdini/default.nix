{ callPackage, buildFHSUserEnv, undaemonize, unwrapped ? callPackage ./runtime.nix {} }:

let
  houdini-runtime = callPackage ./runtime.nix { };
in buildFHSUserEnv {
  name = houdini-runtime.name;

  extraBuildCommands = ''
    mkdir -p $out/usr/lib/sesi
  '';

  passthru = {
    unwrapped = houdini-runtime;
  };

  runScript = "${undaemonize}/bin/undaemonize ${houdini-runtime}/bin/houdini";
}
