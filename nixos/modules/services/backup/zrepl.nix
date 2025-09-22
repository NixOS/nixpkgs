{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.zrepl;
  format = pkgs.formats.yaml { };
  configFile = format.generate "zrepl.yml" cfg.settings;
in
{
  meta.maintainers = with lib.maintainers; [ cole-h ];

  options = {
    services.zrepl = {
      enable = lib.mkEnableOption "zrepl";

      package = lib.mkPackageOption pkgs "zrepl" { };

      settings = lib.mkOption {
        default = { };
        description = ''
          Configuration for zrepl. See <https://zrepl.github.io/configuration.html>
          for more information.
        '';
        type = lib.types.submodule {
          freeformType = format.type;
        };
      };
    };
  };

  ### Implementation ###

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # zrepl looks for its config in this location by default. This
    # allows the use of e.g. `zrepl signal wakeup <job>` without having
    # to specify the storepath of the config.
    environment.etc."zrepl/zrepl.yml".source = configFile;

    systemd.packages = [ cfg.package ];

    # Note that pkgs.zrepl copies and adapts the upstream systemd unit, and
    # the fields defined here only override certain fields from that unit.
    systemd.services.zrepl = {
      requires = [ "local-fs.target" ];
      wantedBy = [ "zfs.target" ];
      after = [ "zfs.target" ];

      path = [ config.boot.zfs.package ];
      restartTriggers = [ configFile ];

      serviceConfig = {
        Restart = "on-failure";
      };
    };
  };
}
