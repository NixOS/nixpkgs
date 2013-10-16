{ system ? builtins.currentSystem }:

with import ../lib/testing.nix { inherit system; };

runInMachine {
  drv = pkgs.patchelf;
  machine = { config, pkgs, ... }: { services.sshd.enable = true; };
}
