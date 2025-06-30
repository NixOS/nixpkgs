{
  config,
  pkgs,
  lib,
  ...
}:

{

  ###### interface

  options = {

    programs.system-config-printer = {

      enable = lib.mkEnableOption "system-config-printer, a Graphical user interface for CUPS administration";

    };

  };

  ###### implementation

  config = lib.mkIf config.programs.system-config-printer.enable {

    environment.systemPackages = [
      pkgs.system-config-printer
    ];

    services.system-config-printer.enable = true;

  };

}
