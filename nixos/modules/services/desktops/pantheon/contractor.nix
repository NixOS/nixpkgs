# Contractor

{ config, pkgs, lib, ... }:

with lib;

{


  ###### implementation

  config = mkIf config.services.pantheon.contractor.enable {

    

  };

}
