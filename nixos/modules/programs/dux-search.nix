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

  cfg = config.programs.dux-search;
in
{
  imports = [
    (lib.mkRenamedOptionModule [ "programs" "dsearch" ] [ "programs" "dux-search" ])
  ];

  options.programs.dux-search = {
    enable = mkEnableOption "Dux Search, a fast filesystem search service with fuzzy matching";

    package = mkPackageOption pkgs "dux-search" { };

    systemd = {
      enable = mkEnableOption "systemd user service for Dux Search" // {
        default = true;
      };

      target = mkOption {
        type = types.str;
        default = "default.target";
        description = ''
          The systemd target that will automatically start the Dux Search service.

          By default, Dux Search starts with the user session (`default.target`).
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

  meta.teams = [ lib.teams.duxlabs ];
}
