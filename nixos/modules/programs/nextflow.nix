{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.nextflow;
in
{
  options.programs.nextflow = {
    enable = lib.mkEnableOption "Nextflow";

    package = lib.mkPackageOption pkgs "nextflow" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
    ];
    services.envfs.enable = true;
  };

  meta = {
    maintainers = with lib.maintainers; [ rollf ];
  };
}
