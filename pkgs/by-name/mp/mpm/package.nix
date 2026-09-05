{
  mpm-unwrapped,
  lib,
  buildFHSEnv,
  pam,
  zlib,
}:

buildFHSEnv {
  pname = "mpm";
  inherit (mpm-unwrapped) version;

  executableName = mpm-unwrapped.meta.mainProgram;
  runScript = lib.getExe mpm-unwrapped;

  targetPkgs = _: [
    pam
    zlib
  ];

  meta = mpm-unwrapped.meta // {
    platforms = [ "x86_64-linux" ];
  };
}
