{config, pkgs, ...}:

let
  cfg = config.services.fuppesd;
in

with pkgs.lib;

{
  options = {
    services.fuppesd = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = ''
          Enables Fuppes (UPnP A/V Media Server).  Can be used to watch
          photos, video and listen to music from a phone/tv connected to the
          local network.
        '';
      };

      name = mkOption {
        example = "Media Center";
        type = with types; uniq string;
        description = ''
          Enables Fuppes (UPnP A/V Media Server).  Can be used to watch
          photos, video and listen to music from a phone/tv connected to the
          local network.
        '';
      };

      log = {
        level = mkOption {
          default = 0;
          example = 3;
          type = with types; uniq int;
          description = ''
            Logging level of fuppes, An integer between 0 and 3.
          '';
        };

        file = mkOption {
          default = "/var/log/fuppes.log";
          type = with types; uniq string;
          description = ''
            File which will contains the log produced by the daemon.
          '';
        };
      };

      config = mkOption {
        example = "/etc/fuppes/fuppes.cfg";
        type = with types; uniq string;
        description = ''
          Mutable configuration file which can be edited with the web
          interface.  Due to possible modification, double quote the full
          path of the filename stored in your filesystem to avoid attempts
          to modify the content of the nix store.
        '';
      };

      vfolder = mkOption {
        default = ./fuppes/vfolder.cfg;
        example = /etc/fuppes/vfolder.cfg;
        description = ''
          XML file describing the layout of virtual folder visible by the
          client.
        '';
      };

      database = mkOption {
        default = "/var/lib/fuppes/fuppes.db";
        type = with types; uniq string;
        description = ''
          Database file which index all shared files.
        '';
      };

      ## At the moment, no plugins are packaged.
      /*
      plugins = mkOption {
        type = with types; listOf package;
        description = ''
          List of Fuppes plugins.
        '';
      };
      */

      user = mkOption {
        default = "root"; # The default is not secure.
        example = "fuppes";
        type = with types; uniq string;
        description = ''
          Name of the user which own the configuration files and under which
          the fuppes daemon will be executed.
        '';
      };

    };
  };

  config = mkIf cfg.enable {
    jobs.fuppesd = {
      description = "UPnP A/V Media Server. (${cfg.name})";
      startOn = "ip-up";
      daemonType = "fork";
      exec = ''/var/setuid-wrappers/sudo -u ${cfg.user} -- ${pkgs.fuppes}/bin/fuppesd --friendly-name ${cfg.name} --log-level ${toString cfg.log.level} --log-file ${cfg.log.file} --config-file ${cfg.config} --vfolder-config-file ${cfg.vfolder} --database-file ${cfg.database}'';
    };

    services.fuppesd.name = mkDefault config.networking.hostName;

    security.sudo.enable = true;
  };
}
