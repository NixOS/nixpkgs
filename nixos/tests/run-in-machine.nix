{ pkgs, system ? builtins.currentSystem, ... }:

with import <nixpkgs/lib/testing/testing.nix> { inherit system; };

runInMachine {
  drv = pkgs.hello;
  machine = { config, pkgs, ... }: { /* services.sshd.enable = true; */ };
}
