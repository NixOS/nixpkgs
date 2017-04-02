{ config, options, pkgs, lib, ... }:

(import  ./bitcoin-core-generic.nix {
  inherit config options pkgs lib;

  name = "bitcoind";
  description = "Bitcoin's distributed currency daemon";
  defaultUser = "bitcoin";
  userDescription = "Bitcoin daemon user";
  defaultGroup = "bitcoin";
  groupDescription = "Bitcoin daemon group";
  defaultPackage = pkgs.altcoins.bitcoind;
  daemonExec = "bitcoind";
  cliExec = "bitcoin-cli";

})
