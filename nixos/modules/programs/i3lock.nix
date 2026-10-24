{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.programs.i3lock;

in
{

  ###### interface

  options = {
    programs.i3lock = {
      enable = lib.mkEnableOption "i3lock";
      package = lib.mkPackageOption pkgs "i3lock" {
        example = "i3lock-color";
      };
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ cfg.package ];

  };

}
