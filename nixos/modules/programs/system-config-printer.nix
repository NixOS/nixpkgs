{ config, pkgs, lib, ... }:

with lib;

{

  ###### interface

  options = {

    programs.system-config-printer = {

      enable = mkEnableOption (lib.mdDoc "system-config-printer, a Graphical user interface for CUPS administration");

    };

  };


  ###### implementation

  config = mkIf config.programs.system-config-printer.enable {

    environment.systemPackages = [
      pkgs.system-config-printer
    ];

    services.system-config-printer.enable = true;

  };

}
