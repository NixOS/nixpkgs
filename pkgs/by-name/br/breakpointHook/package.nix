{
  lib,
  stdenv,
  buildPackages,
  callPackage,

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
  meta = {
    broken = !stdenv.buildPlatform.isLinux;
    license = lib.licenses.mit;
  };
  substitutions = {
    attach = "${attach}/bin/attach";
    # The default interactive shell in case $debugShell is not set in the derivation.
    # Can be overridden to zsh or fish, etc.
    # This shell is also used to load the env variables before the $debugShell is started.
    bashInteractive = lib.getExe bashInteractive;
  };
  passthru.tests = {
    can-attach-valid-id = callPackage ./test-can-attach-valid-id.nix { inherit attach; };
    cannot-attach-invalid-id = callPackage ./test-cannot-attach-invalid-id.nix { inherit attach; };
  };
} ./breakpoint-hook.sh
