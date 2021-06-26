{ callPackage, buildFHSUserEnv, undaemonize, unwrapped ? callPackage ./runtime.nix {} }:

let
  houdini-runtime = callPackage ./runtime.nix { };
in buildFHSUserEnv {
  name = "houdini-${houdini-runtime.version}";

  passthru = {
    unwrapped = houdini-runtime;
  };

  runScript = "${undaemonize}/bin/undaemonize ${houdini-runtime}/bin/houdini";
}

