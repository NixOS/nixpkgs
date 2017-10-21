{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.services.rsyncd;

  motdFile = builtins.toFile "rsyncd-motd" cfg.motd;

  foreach = attrs: f:
    concatStringsSep "\n" (mapAttrsToList f attrs);

  cfgFile = ''
    ${optionalString (cfg.motd != "") "motd file = ${motdFile}"}
    ${optionalString (cfg.address != "") "address = ${cfg.address}"}
    ${optionalString (cfg.port != 873) "port = ${toString cfg.port}"}
    ${cfg.extraConfig}
    ${foreach cfg.modules (name: module: ''
      [${name}]
      ${foreach module (k: v:
        "${k} = ${v}"
      )}
    '')}
  '';
in

{
  options = {
    services.rsyncd = {

      enable = mkOption {
        default = false;
        description = "Whether to enable the rsync daemon.";
      };

      motd = mkOption {
        type = types.string;
        default = "";
        description = ''
          Message of the day to display to clients on each connect.
          This usually contains site information and any legal notices.
        '';
      };

      port = mkOption {
        default = 873;
        type = types.int;
        description = "TCP port the daemon will listen on.";
      };

      address = mkOption {
        default = "";
        example = "192.168.1.2";
        description = ''
          IP address the daemon will listen on; rsyncd will listen on
          all addresses if this is not specified.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
            Lines of configuration to add to rsyncd globally.
            See <command>man rsyncd.conf</command> for options.
          '';
      };

      modules = mkOption {
        default = {};
        description = ''
            A set describing exported directories.
            See <command>man rsyncd.conf</command> for options.
          '';
        type = types.attrsOf (types.attrsOf types.str);
        example =
          { srv =
             { path = "/srv";
               "read only" = "yes";
               comment = "Public rsync share.";
             };
          };
      };

      user = mkOption {
        type = types.str;
        default = "root";
        description = ''
          The user to run the daemon as.
          By default the daemon runs as root.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "root";
        description = ''
          The group to run the daemon as.
          By default the daemon runs as root.
        '';
      };

    };
  };

  ###### implementation

  config = mkIf cfg.enable {

    environment.etc."rsyncd.conf".text = cfgFile;

    systemd.services.rsyncd = {
      description = "Rsync daemon";
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ config.environment.etc."rsyncd.conf".source ];
      serviceConfig = {
        ExecStart = "${pkgs.rsync}/bin/rsync --daemon --no-detach";
        User = cfg.user;
        Group = cfg.group;
      };
    };
  };
}
