{ config, lib, pkgs, ... }:
let
  cfg = config.services.kratos;

  upstreamKratosVersion = lib.getVersion pkgs.kratos;

  kratosPackage = if config.services.kratos.enable
    then
      config.services.kratos.package
    else
      pkgs.kratos;

  kratosVersion = lib.getVersion kratosPackage;
in {
  options = {
    services.kratos = {
      enable = lib.mkEnableOption "Kratos, Libre and open source identity server";

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.kratos;
        defaultText = "pkgs.kratos";
        description = ''
          The kratos package to use
        '';
      };
    };
  };

  # config = lib.mkIf cfg.enable {
  # };

  meta.maintainers = [ ];
}
