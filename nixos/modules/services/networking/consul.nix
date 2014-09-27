{ config, lib, pkgs, utils, ... }:

with lib;
let

  dataDir = "/var/lib/consul";
  cfg = config.services.consul;

  configOptions = {
    data_dir = dataDir;
    rejoin_after_leave = true;
  }
  // (if cfg.webUi then { ui_dir = "${pkgs.consul.ui}"; } else { })
  // cfg.extraConfig;

  configFiles = [ "/etc/consul.json" "/etc/consul-addrs.json" ]
    ++ cfg.extraConfigFiles;

  devices = attrValues (filterAttrs (_: i: i != null) cfg.interface);
  systemdDevices = flip map devices
    (i: "sys-subsystem-net-devices-${utils.escapeSystemdPath i}.device");
in
{
  options = {

    services.consul = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enables the consul daemon.
        '';
      };

      webUi = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enables the web interface on the consul http port.
        '';
      };

      interface = {

        advertise = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            The name of the interface to pull the advertise_addr from.
          '';
        };

        bind = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            The name of the interface to pull the bind_addr from.
          '';
        };

      };

      forceIpv4 = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether we should force the interfaces to only pull ipv4 addresses.
        '';
      };

      dropPrivileges = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether the consul agent should be run as a non-root consul user.
        '';
      };

      extraConfig = mkOption {
        default = { };
        description = ''
          Extra configuration options which are serialized to json and added
          to the config.json file.
        '';
      };

      extraConfigFiles = mkOption {
        default = [ ];
        type = types.listOf types.str;
        description = ''
          Additional configuration files to pass to consul
          NOTE: These will not trigger the service to be restarted when altered.
        '';
      };

    };

  };

  config = mkIf cfg.enable {

    users.extraUsers."consul" = {
      description = "Consul agent daemon user";
      uid = config.ids.uids.consul;
    };

    environment = {
      etc."consul.json".text = builtins.toJSON configOptions;
      systemPackages = with pkgs; [ consul ];
    };

    systemd.services.consul = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ] ++ systemdDevices;
      bindsTo = systemdDevices;
      restartTriggers = [ config.environment.etc."consul.json".source ];

      serviceConfig = {
        ExecStart = "@${pkgs.consul}/bin/consul consul agent"
          + concatMapStrings (n: " -config-file ${n}") configFiles;
        ExecStop = "${pkgs.consul}/bin/consul leave";
        ExecReload = "${pkgs.consul}/bin/consul reload";
        PermissionsStartOnly = true;
        User = if cfg.dropPrivileges then "consul" else null;
      };

      path = with pkgs; [ iproute gnugrep gawk ];
      preStart = ''
        mkdir -m 0700 -p ${dataDir}
        chown -R consul ${dataDir}

        # Determine interface addresses
        getAddrOnce () {
          ip addr show dev "$1" \
            | grep 'inet${optionalString (cfg.forceIpv4) " "}.*scope global' \
            | awk -F '[ /\t]*' '{print $3}' | head -n 1
        }
        getAddr () {
          ADDR="$(getAddrOnce $1)"
          LEFT=60 # Die after 1 minute
          while [ -z "$ADDR" ]; do
            sleep 1
            LEFT=$(expr $LEFT - 1)
            if [ "$LEFT" -eq "0" ]; then
              echo "Address lookup timed out"
              exit 1
            fi
            ADDR="$(getAddrOnce $1)"
          done
          echo "$ADDR"
        }
        echo "{" > /etc/consul-addrs.json
      ''
      + concatStrings (flip mapAttrsToList cfg.interface (name: i:
        optionalString (i != null) ''
          echo "    \"${name}_addr\": \"$(getAddr "${i}")\"," >> /etc/consul-addrs.json
        ''))
      + ''
        echo "    \"\": \"\"" >> /etc/consul-addrs.json
        echo "}" >> /etc/consul-addrs.json
      '';
    };

  };
}
