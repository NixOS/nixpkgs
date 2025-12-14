{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    mkPackageOption
    types
    ;

  cfg = config.programs.dsearch;
in
{
  options.programs.dsearch = {
    enable = mkEnableOption "dsearch, a fast filesystem search service with fuzzy matching";

    package = mkPackageOption pkgs "dsearch" { };

    systemd = {
      enable = mkEnableOption "systemd user service for dsearch" // {
        default = true;
      };

      target = mkOption {
        type = types.str;
        default = "default.target";
        description = ''
          The systemd target that will automatically start the dsearch service.

          By default, dsearch starts with the user session (`default.target`).
          You can change this to `graphical-session.target` if you only want
          it to run in graphical sessions.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    systemd.user.services.dsearch.wantedBy = mkIf cfg.systemd.enable [ cfg.systemd.target ];
  };

  meta.maintainers = with lib.maintainers; [ luckshiba ];
}
