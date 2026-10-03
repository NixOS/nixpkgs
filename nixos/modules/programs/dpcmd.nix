{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.dpcmd;
in
{
  options.programs.dpcmd = {
    enable = lib.mkEnableOption ''
      configure dpcmd udev rules and
      install dpcmd as system package
    '';
    package = lib.mkPackageOption pkgs "dediprog-sf100" { };
  };

  config = lib.mkIf cfg.enable {
    services.udev.packages = [ cfg.package ];
    environment.systemPackages = [ cfg.package ];
  };

  meta.maintainers = with lib.maintainers; [ felixsinger ];
}
