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
    enable = lib.mkEnableOption "The open source CFD toolkit (openfoam.org)";
    package = lib.mkPackageOption pkgs "openfoam-org" { };
  };
  config = {
    environment = lib.mkIf cfg.enable {
      # hardcoded OpenFOAM-12 may need to be changed in the futre to accomodate for the openfoam.com fork
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
