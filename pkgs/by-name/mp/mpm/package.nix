{
  mpm-unwrapped,
  lib,
  versionCheckHook,
  buildFHSEnv,
  pam,
  zlib,
}:
(buildFHSEnv {
  pname = "mpm";
  inherit (mpm-unwrapped) version;

  executableName = mpm-unwrapped.meta.mainProgram;
  runScript = lib.getExe mpm-unwrapped;

  targetPkgs = _: [
    pam
    zlib
  ];

  meta = mpm-unwrapped.meta // {
    # Support only Linux platforms for the wrapped binary.
    # List not hardcoded in case other Linux/Darwin platforms become supported.
    platforms = lib.intersectLists mpm-unwrapped.meta.platforms lib.platforms.linux;
  };
}).overrideAttrs # attributes which don't work as intended otherwise
  {
    doInstallCheck = true;
    nativeInstallCheckInputs = [ versionCheckHook ];

    # for nixpkgs-vet
    strictDeps = true;
    __structuredAttrs = true;
  }
