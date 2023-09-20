{ config, lib, ... }:
let
  inherit (lib) stringAfter;
in {

  imports = [ ./etc.nix ];

  config = {
    system.activationScripts.etc =
      stringAfter [ "users" "groups" ] config.system.build.etcActivationCommands;
  };
}
