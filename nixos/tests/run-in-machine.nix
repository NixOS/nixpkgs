{ system ? builtins.currentSystem }:

with import ../lib/testing.nix { inherit system; };

runInMachine {
  drv = pkgs.hello;
  machine = { config, pkgs, ... }: { /* services.sshd.enable = true; */ };
}
