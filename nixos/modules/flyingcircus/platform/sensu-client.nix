{ config, pkgs, lib, ... }:

with lib;

{

  config = lib.mkIf (builtins.hasAttr "sensuserver" config.flyingcircus.enc_services) {
    flyingcircus.services.sensu-client = let
      servercfg = config.flyingcircus.enc_services.sensuserver;
    in
    {
      enable = true;
      server = builtins.head servercfg.addresses;
      password = servercfg.password;
    };
  };

}
