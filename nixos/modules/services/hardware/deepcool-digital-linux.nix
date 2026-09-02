{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.hardware.deepcool-digital-linux;
in
{
  meta.maintainers = [ lib.maintainers.NotAShelf ];

  options.services.hardware.deepcool-digital-linux = {
    enable = lib.mkEnableOption "DeepCool Digital monitoring daemon";
    package = lib.mkPackageOption pkgs "deepcool-digital-linux" { };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = lib.literalExpression ''
        [
          # Change the update interval
          "--update 750"
          # Enable the alarm
          "--alarm"
        ]
      '';
      description = ''
        Extra command line arguments to be passed to the deepcool-digital-linux daemon.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    systemd.services.deepcool-digital-linux = {
      description = "DeepCool Digital";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        StateDirectory = "deepcool-digital-linux";
        WorkingDirectory = "/var/lib/deepcool-digital-linux";
        ExecStart = "${lib.getExe cfg.package} ${lib.escapeShellArgs cfg.extraArgs}";
        Restart = "always";
      };
    };
  };
}
