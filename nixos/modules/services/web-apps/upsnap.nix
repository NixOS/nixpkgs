{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.upsnap;
in {
  options.services.upsnap = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        Upsnap, a simple wake on lan web app.

        TIP: To configure target machines which you want to wakeup:
        - enable `Wake on LAN/PCIE` in your BIOS/UEFI firmware
        - enable WoL on your network interface, with whichever OS & app you use for networking
          for NixOS with NM use `networking.networkmanager.ensureProfiles.profiles.<name>.802-3-ethernet.wake-on-lan = 64;`
          then reboot and make sure it persisted <https://wiki.debian.org/WakeOnLan#Checking_WOL>
      '';
    };

    package = mkOption {
      default = pkgs.upsnap;
      type = types.package;
      description = mdDoc "Upsnap package to use.";
    };

    address = mkOption {
      type = types.str;
      default = "0.0.0.0";
      example = "127.0.0.1";
      description = mdDoc "Web interface address.";
    };

    port = mkOption {
      type = types.port;
      default = 8090;
      description = mdDoc "Web interface port.";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = true;
      description = mdDoc "Allow traffic to TCP port that Upsnap's webui is running on.";
    };

    dataDir = mkOption {
      default = "/var/lib/upsnap";
      type = types.path;
      description = mdDoc "Location for persistent data.";
    };

    accessiblePackages = mkOption {
      default = [pkgs.nmap];
      example = [pkgs.nmap pkgs.sleep-on-lan pkgs.samba pkgs.sshpass];
      type = types.listOf types.package;
      description = mdDoc ''
        Packages that will be available to Upsnap's environment.
        The app makes use of some 3rd party tools & provides samples of optional commands.
        You have to include those desired apps in this set. For example:
        - network scanning requires `pkgs.nmap`
        - putting machines to sleep requires `pkgs.sleep-on-lan` (and a daemon of sleep-on-lan running on that machine)
        - shutting down Windows machines with the webui-suggested command (net rpc) requires `pkgs.samba`
        - shutting down Linux machines with the webui-suggested command requires `pkgs.sshpass`
        - ...
      '';
    };

    extraServeArgs = mkOption {
      type = types.str;
      default = "";
      example = "--dev --origins <...> --https <...>";
      description = mdDoc "Text that will be appended to the end of `upsnap serve` command. Use `upsnap serve --help` to discover available cli options.";
    };

    extraConfig = mkOption {
      default = {
        UPSNAP_INTERVAL = "@every 10s";
        UPSNAP_SCAN_RANGE = "192.168.1.0/24";
        UPSNAP_SCAN_TIMEOUT = "500ms";
        UPSNAP_PING_PRIVILEGED = "true";
        UPSNAP_WEBSITE_TITLE = "Upsnap";
      };
      type = types.submodule {
        freeformType = types.str;
        options = {
          UPSNAP_INTERVAL = mkOption {
            default = "@every 10s";
            type = types.str;
            description = mdDoc "Sets the interval in which the devices are pinged";
          };
          UPSNAP_SCAN_RANGE = mkOption {
            default = "192.168.1.0/24";
            type = types.str;
            description = mdDoc "Scan range is used for device discovery on local network";
          };
          UPSNAP_SCAN_TIMEOUT = mkOption {
            default = "500ms";
            type = types.str;
            description = mdDoc "Scan timeout is nmap's --host-timeout value to wait for devices (https://nmap.org/book/man-performance.html)";
          };
          UPSNAP_PING_PRIVILEGED = mkOption {
            default = "true";
            type = types.str;
            description = mdDoc "Set to false if you don't have root user permissions";
          };
          UPSNAP_WEBSITE_TITLE = mkOption {
            default = "Upsnap";
            type = types.str;
            description = mdDoc "Custom website title";
          };
        };
      };
      description = mdDoc "Extra environment variable settings. Preloaded with defaults you can choose to override.";
    };

    adminUsersFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/secrets/upsnap-admins.env";
      description = lib.mdDoc ''
        Environment variables from which Upsnap admin users will be created.
        Supports passwords being changed, however to delete a user you have to manually run `sudo upsnap admin delete <user> --dir <dataDir>`.
        The format of the environment variables must be:
        ```
          UPSNAP_ADMIN_1_EMAIL=alice@email.com
          UPSNAP_ADMIN_1_PASSWORD=alicepassword
          UPSNAP_ADMIN_2_EMAIL=bob@email.com
          UPSNAP_ADMIN_2_PASSWORD=bobpassword
        ```
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];

    systemd.services.upsnap = {
      description = "Upsnap, a simple wake on lan web app";
      after = [
        "network.target"
        "network-online.target"
        "systemd-resolved.service"
      ];
      wants = [
        "network.target"
        "network-online.target"
        "systemd-resolved.service"
      ];
      wantedBy = ["multi-user.target"];
      environment =
        {
          # upsnap creates an empty `$HOME/.config/upsnap` even when `--dir` arg is set
          XDG_CONFIG_HOME = cfg.dataDir;
          HOME = cfg.dataDir;
        }
        // lib.mapAttrs (_: toString) cfg.extraConfig;
      path = cfg.accessiblePackages;
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/upsnap serve --http ${cfg.address}:${builtins.toString cfg.port} --dir ${cfg.dataDir} ${cfg.extraServeArgs}";
        EnvironmentFile = mkIf (cfg.adminUsersFile != null) (builtins.toString cfg.adminUsersFile);
        Type = "simple";
        Restart = "on-failure";
        # i think we would only need this for non-root user
        AmbientCapabilities = "CAP_NET_RAW";
        CapabilityBoundingSet = "CAP_NET_RAW";
      };
      preStart = let
        upsnap = "${cfg.package}/bin/upsnap";
      in ''
        ${upsnap} migrate up --dir ${cfg.dataDir}
        declare -A names
        declare -A passwords
        for var in $(env | grep '^UPSNAP_ADMIN_'); do
            name=$(echo $var | cut -d '=' -f 1)
            value=$(echo $var | cut -d '=' -f 2-)
            number=$(echo $name | grep -o '[0-9]\+')
            if [[ $name == *_EMAIL ]]; then
                names[$number]=$value
            elif [[ $name == *_PASSWORD ]]; then
                passwords[$number]=$value
            fi
        done
        for number in "''${!names[@]}"; do
            if [ -n "''${names[$number]}" ] && [ -n "''${passwords[$number]}" ]; then
                output=$(${upsnap} admin create ''${names[$number]} ''${passwords[$number]} --dir ${cfg.dataDir})
                if echo "$output" | grep -q "UNIQUE constraint failed"; then
                    output=$(${upsnap} admin update ''${names[$number]} ''${passwords[$number]} --dir ${cfg.dataDir})
                fi
                if echo "$output" | grep -q "Success"; then
                    echo "Successfully initialized user $number"
                else
                    echo "Failed to initialize user $number"
                fi
            fi
        done
      '';
    };

    systemd.tmpfiles.rules = ["d '${cfg.dataDir}' 0700 root root - -"];

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [cfg.port];
    };
  };
}

