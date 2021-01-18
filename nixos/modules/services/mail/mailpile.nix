{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.mailpile;
  instance = name: { localPort, package, user, group, vhost, location, ... }: let
    location' = if builtins.substring 0 1 location == "/"
                then location
                else "/${location}";
    address = "http://localhost:${builtins.toString localPort}${location'}";
    user-name = if user == null then "mailpile-${name}" else user;
  in {
    inherit package;

    users = {
      ${if user != null then null else user-name} = {
        isSystemUser = true;
        description = "Mailpile user for ${name}";
        createHome = true;
        home = "/var/lib/mailpile/${name}";
      };
    };

    services."mailpile-${name}" = {
      description = "Mailpile server for ${name}";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = user-name;
        Group = group;
        ExecStart = ''${package}/bin/mailpile --www "${address}" --wait'';
        # mixed - first send SIGINT to main process,
        # then after 2min send SIGKILL to whole group if necessary
        KillMode = "mixed";
        KillSignal = "SIGINT";  # like Ctrl+C - safe mailpile shutdown
        TimeoutSec = 20;  # wait 20s until SIGKILL
      };
    };

    vhosts.${vhost}.locations.${location'}.proxyPass = address;
  };
in {
  disabledModules = [ "services/networking/mailpile.nix" ];

  options.services.mailpile = mkOption {
    default = { };

    description = "Named instances of Mailpile to run";

    type = types.attrsOf (types.submodule {
      options = {
        localPort = mkOption {
          default = 33144;
          type = types.port;
          description = ''
            Local port to listen on.
          '';
        };

        package = mkOption {
          default = pkgs.mailpile;
          defaultText = "pkgs.mailpile";
          type = types.package;
          description = ''
            Mailpile package to use.
          '';
        };

        user = mkOption {
          default = null;
          type = types.nullOr types.str;
          description = ''
            Name of the user to run as.  Pass `null` to create a new
            dedicated user named `mailpile-<instance name>` with home
            under `/var/lib/mailpile`.
          '';
        };

        group = mkOption {
          default = "nogroup";
          type = types.str;
          description = ''
            Name of the group to run as.
          '';
        };

        vhost = mkOption {
          default = null;
          type = types.nullOr types.str;
          description = ''
            Name of the nginx virtual host on which to expose Mailpile.
            Pass `null` to disable nginx integration.
          '';
        };

        location = mkOption {
          default = "/";
          type = types.str;
          description = ''
            HTTP location at which Mailpile will be exposed.
          '';
        };
      };
    });

    example = {
      my-app = { localPort = 33144; };
    };
  };

  config = let
    c = mapAttrsToList instance cfg;
    vhosts = catAttrs "vhosts" c;
  in mkIf (cfg != { }) {
    systemd.tmpfiles.rules = [ "d /var/lib/mailpile 0755 root root - -" ];
    environment.systemPackages = catAttrs "package" c;
    users.users = mkMerge (catAttrs "users" c);
    systemd.services = mkMerge (catAttrs "services" c);
    services.nginx.enable = builtins.length vhosts > 0;
    services.nginx.virtualHosts = mkMerge vhosts;
  };
}
