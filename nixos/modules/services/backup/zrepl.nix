{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.services.zrepl;
  format = pkgs.formats.yaml { };
  configFile = format.generate "zrepl.yml" cfg.settings;
in
{
  meta.maintainers = with maintainers; [ cole-h ];

  options = {
    services.zrepl = {
      enable = mkEnableOption "zrepl";

      settings = mkOption {
        default = { };
        description = ''
          Configuration for zrepl. See <link
          xlink:href="https://zrepl.github.io/configuration.html"/>
          for more information.
        '';
        type = types.submodule {
          freeformType = format.type;
        };
      };
    };
  };

  ### Implementation ###

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.zrepl ];

    # zrepl looks for its config in this location by default. This
    # allows the use of e.g. `zrepl signal wakeup <job>` without having
    # to specify the storepath of the config.
    environment.etc."zrepl/zrepl.yml".source = configFile;

    systemd.packages = [ pkgs.zrepl ];
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
