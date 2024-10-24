{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.openfoam;
in
{
  meta.maintainers = with lib.maintainers; [ gusgibbon ];

  options.programs.openfoam = {
    enable = lib.mkEnableOption "Open source computational fluid dynamics toolkit";
    package = lib.mkPackageOption pkgs "openfoam-org" { };
  };
  config = {
    environment = lib.mkIf cfg.enable {
      # This may change in the future to allow use of this module with the openfoam.com fork
      interactiveShellInit = ''
        alias ofoam="source ${cfg.package}/opt/OpenFOAM-12/etc/bashrc"
      '';
      systemPackages = with pkgs; [
        mpi
        mpi.dev
      ];
    };
  };
}
