{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.powerdns;
  powerdns = pkgs.powerdns;

  # Read the configured directory and use all pdns-*.conf to start a
  # powerdns instance.
  instance_names =
    map
      (instance_name:
        removeSuffix ".conf"
          (removePrefix "pdns-" instance_name))
      (attrNames
        (filterAttrs
          (filename: type:
            (type == "regular") &&
            (lib.hasPrefix "pdns-" filename) &&
            (lib.hasSuffix ".conf" filename)
            )
          (
           if builtins.pathExists cfg.configDir
           then builtins.readDir cfg.configDir
           else {})));

in

{

  ###### interface
  options = {

    services.powerdns = {

      enable = mkOption {
        default = false;
        description = "
          Whether to enable powerdns domain name server.
        ";
      };

      configDir = mkOption {
        type = types.path;
        description = ''
          Where to find the configuration files.

          Add pdns-<name>.conf files into this directory. A separate powerdns
          instance will bestarted for each config file. It's up to you to
          configure non conflicting ip addresses in the configuration.
        '';
      };

    };

  };

  config = mkIf config.services.powerdns.enable {

    users.extraUsers.powerdns = {
      description = "powerdns daemon user";
      uid = config.ids.uids.powerdns;
      group = "nogroup";
    };

   environment.systemPackages = [ pkgs.powerdns ];

    systemd.services = builtins.listToAttrs
      (map
        (instance_name:
          { name = "powerdns_${instance_name}";
            value = {
              wantedBy = [ "multi-user.target" ];
              after = ["postgresql.target"];
              path = [ powerdns ];
              serviceConfig = {
                #User = "powerdns";
                Type = "forking";
                # Restart = "on-failure";
                PrivateTmp = "true";
                PrivateDevices = "true";
                CapabilityBoundingSet = "CAP_NET_BIND_SERVICE CAP_SETGID CAP_SETUID";
                NoNewPrivileges = "true";
                # ProtectSystem = "full will disallow write access to /etc and /usr, possibly
                # not being able to write slaved-zones into sqlite3 or zonefiles.
                ProtectSystem = "full";
                ProtectHome = "true";
                RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6";
                ExecStart = ''
                  ${powerdns}/bin/pdns_server \
                    --config-dir=${cfg.configDir} \
                    --config-name=${instance_name} \
                    --setuid=powerdns \
                    --setgid=nogroup \
                    --daemon
                  '';
              };
            };
        })
      instance_names);
  };
}
