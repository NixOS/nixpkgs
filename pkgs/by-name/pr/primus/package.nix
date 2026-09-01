# For a 64bit + 32bit system the LD_LIBRARY_PATH must contain both the 32bit and 64bit primus
# libraries. Providing a different primusrun for each architecture will not work as expected. EG:
# Using steam under wine can involve both 32bit and 64bit process. All of which inherit the
# same LD_LIBRARY_PATH.
# Other distributions do the same.
{
  stdenv,
  pkgsi686Linux,
  lib,
  primus-lib,
  writeScriptBin,
  runtimeShell,
  primus-lib_i686 ?
    if stdenv.hostPlatform.system == "x86_64-linux" then pkgsi686Linux.primus-lib else null,
  useNvidia ? true,
}:

let
  # We override stdenv in case we need different ABI for libGL
  primus-lib_ = primus-lib.override { inherit stdenv; };
  primus-lib_i686_ = primus-lib_i686.override { stdenv = pkgsi686Linux.stdenv; };

  primus = if useNvidia then primus-lib_ else primus-lib_.override { nvidia_x11 = null; };
  primus_i686 =
    if useNvidia then primus-lib_i686_ else primus-lib_i686_.override { nvidia_x11 = null; };
  ldPath = lib.makeLibraryPath (
    lib.filter (x: x != null) (
      [
        primus
        primus.glvnd
      ]
      ++ lib.optionals (primus-lib_i686 != null) [
        primus_i686
        primus_i686.glvnd
      ]
    )
  );

in
writeScriptBin "primusrun" ''
  #!${runtimeShell}
  export LD_LIBRARY_PATH=${ldPath}''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH
  # https://bugs.launchpad.net/ubuntu/+source/bumblebee/+bug/1758243
  export __GLVND_DISALLOW_PATCHING=1
  exec "$@"
''
