{
  lib,
  stdenv,

  bash,
  bashInteractive,
  coreutils,
  makeSetupHook,
  procps,
  util-linux,
  writeShellScriptBin,
}:

let
  attach = writeShellScriptBin "attach" ''
    export PATH="${
      lib.makeBinPath [
        bash
        coreutils
        procps # needed for pgrep
        util-linux # needed for nsenter
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
