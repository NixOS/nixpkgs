{ config, options, pkgs, lib, ... }:

(import  ./bitcoin-core-generic.nix {
  inherit config options pkgs lib;

  name = "dashd";
  description = "Dash's distributed currency daemon";
  defaultUser = "dash";
  userDescription = "Dash daemon user";
  defaultGroup = "dash";
  groupDescription = "Dash daemon group";
  defaultPackage = pkgs.altcoins.dashpay;
  daemonExec = "dashd";
  cliExec = "dash-cli";

})
