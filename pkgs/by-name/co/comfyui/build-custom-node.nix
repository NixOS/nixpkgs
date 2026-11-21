{
  lib,
  stdenvNoCC,
}:

# ComfyUI loads custom nodes by adding a directory below `custom_nodes/` to
# `sys.path` and importing its `__init__.py`.  Keep the source tree intact at
# `$out` instead of installing it into `site-packages`; the NixOS module links
# `$out` into the data directory.
#
# `pythonDeps` is deliberately a function instead of `propagatedBuildInputs`:
# it is resolved against the final ComfyUI Python set, so a node can reuse the
# server's exact torch/CUDA stack instead of pinning a second one from a
# separate `python3Packages` instance.
lib.extendMkDerivation {
  constructDrv = stdenvNoCC.mkDerivation;

  excludeDrvArgNames = [
    "installName"
    "pythonDeps"
  ];

  extendDrvArgs =
    finalAttrs:
    {
      pname,
      version,
      src,
      installName ? finalAttrs.pname,
      pythonDeps ? (_: [ ]),
      ...
    }@args:
    {
      inherit pname version src;

      dontBuild = args.dontBuild or true;
      dontConfigure = args.dontConfigure or true;

      installPhase =
        args.installPhase or ''
          runHook preInstall

          mkdir -p $out
          cp -r . $out/

          # Every directory-style ComfyUI node has an __init__.py at its root.
          test -f $out/__init__.py

          runHook postInstall
        '';

      passthru = (args.passthru or { }) // {
        comfyui = {
          isCustomNode = true;
          inherit installName pythonDeps;
        };
      };
    };
}
