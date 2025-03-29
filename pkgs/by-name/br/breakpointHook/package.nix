{
  lib,
  stdenv,
  buildPackages,

  bashInteractive,
  makeSetupHook,
}:

let
  attach = buildPackages.writeShellScriptBin "attach" ''
    export PATH="''${PATH:+''${PATH}:}${
      lib.makeBinPath [
        buildPackages.bash
        buildPackages.coreutils
        buildPackages.util-linuxMinimal # needed for nsenter
      ]
    }"
    exec bash ${./attach.sh} "$@"
  '';
in

makeSetupHook {
  name = "breakpoint-hook";
  meta.broken = !stdenv.buildPlatform.isLinux;
  substitutions = {
    attach = "${attach}/bin/attach";
    # The default interactive shell in case $debugShell is not set in the derivation.
    # Can be overridden to zsh or fish, etc.
    # This shell is also used to load the env variables before the $debugShell is started.
    bashInteractive = lib.getExe bashInteractive;
  };
} ./breakpoint-hook.sh
