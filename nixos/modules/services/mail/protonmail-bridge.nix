{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.protonmail-bridge;
in
{

  options.services.protonmail-bridge = {
    enable = lib.mkEnableOption "protonmail bridge";

    package = lib.mkPackageOption pkgs "protonmail-bridge" { };

    path = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      example = lib.literalExpression "with pkgs; [ pass gnome-keyring ]";
      description = "List of derivations to put in protonmail-bride's path.";
    };

  };
  config = lib.mkIf cfg.enable {
    systemd.user.services.protonmail-bridge = {
      description = "protonmail bridge";
      wantedBy = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/protonmail-bridge --noninteractive --log-level debug";
        Restart = "always";
      };

      path = cfg.path;
    };
    environment.systemPackages = [ cfg.package ];
  };
  meta.maintainers = with lib.maintainers; [ mzacho ];
}
