{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.services.rsyncd;

  motdFile = builtins.toFile "rsyncd-motd" cfg.motd;

  moduleConfig = name:
    let module = getAttr name cfg.modules; in
    "[${name}]\n " + (toString (
       map
         (key: "${key} = ${toString (getAttr key module)}\n")
         (attrNames module)
    ));

  cfgFile = builtins.toFile "rsyncd.conf"
    ''
    ${optionalString (cfg.motd != "") "motd file = ${motdFile}"}
    ${optionalString (cfg.address != "") "address = ${cfg.address}"}
    ${optionalString (cfg.port != 873) "port = ${toString cfg.port}"}
    ${cfg.extraConfig}
    ${toString (map moduleConfig (attrNames cfg.modules))}
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

    };
  };

  ###### implementation

  config = mkIf cfg.enable {

    environment.etc = singleton {
      source = cfgFile;
      target = "rsyncd.conf";
    };

    systemd.services.rsyncd = {
      description = "Rsync daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart = "${pkgs.rsync}/bin/rsync --daemon --no-detach";
    };

  };
}
