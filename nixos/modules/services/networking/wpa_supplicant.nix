{ config, lib, pkgs, utils, ... }:

with lib;

let
  package = if cfg.allowAuxiliaryImperativeNetworks
    then pkgs.wpa_supplicant_ro_ssids
    else pkgs.wpa_supplicant;

  cfg = config.networking.wireless;

  # Content of wpa_supplicant.conf
  generatedConfig = concatStringsSep "\n" (
    (mapAttrsToList mkNetwork cfg.networks)
    ++ optional cfg.userControlled.enable (concatStringsSep "\n"
      [ "ctrl_interface=/run/wpa_supplicant"
        "ctrl_interface_group=${cfg.userControlled.group}"
        "update_config=1"
      ])
    ++ optional cfg.scanOnLowSignal ''bgscan="simple:30:-70:3600"''
    ++ optional (cfg.extraConfig != "") cfg.extraConfig);

  configFile =
    if cfg.networks != {} || cfg.extraConfig != "" || cfg.userControlled.enable
      then pkgs.writeText "wpa_supplicant.conf" generatedConfig
      else "/etc/wpa_supplicant.conf";

  # Creates a network block for wpa_supplicant.conf
  mkNetwork = ssid: opts:
  let
    quote = x: ''"${x}"'';
    indent = x: "  " + x;

    pskString = if opts.psk != null
      then quote opts.psk
      else opts.pskRaw;

    options = [
      "ssid=${quote ssid}"
      (if pskString != null || opts.auth != null
        then "key_mgmt=${concatStringsSep " " opts.authProtocols}"
        else "key_mgmt=NONE")
    ] ++ optional opts.hidden "scan_ssid=1"
      ++ optional (pskString != null) "psk=${pskString}"
      ++ optionals (opts.auth != null) (filter (x: x != "") (splitString "\n" opts.auth))
      ++ optional (opts.priority != null) "priority=${toString opts.priority}"
      ++ optional (opts.extraConfig != "") opts.extraConfig;
  in ''
    network={
    ${concatMapStringsSep "\n" indent options}
    }
  '';

  # Creates a systemd unit for wpa_supplicant bound to a given (or any) interface
  mkUnit = iface:
    let
      deviceUnit = optional (iface != null) "sys-subsystem-net-devices-${utils.escapeSystemdPath iface}.device";
      configStr = if cfg.allowAuxiliaryImperativeNetworks
        then "-c /etc/wpa_supplicant.conf -I ${configFile}"
        else "-c ${configFile}";
    in {
      description = "WPA Supplicant instance" + optionalString (iface != null) " for interface ${iface}";

      after = deviceUnit;
      before = [ "network.target" ];
      wants = [ "network.target" ];
      requires = deviceUnit;
      wantedBy = [ "multi-user.target" ];
      stopIfChanged = false;

      path = [ package ];

      script =
      ''
        if [ -f /etc/wpa_supplicant.conf -a "/etc/wpa_supplicant.conf" != "${configFile}" ]; then
          echo >&2 "<3>/etc/wpa_supplicant.conf present but ignored. Generated ${configFile} is used instead."
        fi

        iface_args="-s ${optionalString cfg.dbusControlled "-u"} -D${cfg.driver} ${configStr}"

        ${if iface == null then ''
          # detect interfaces automatically

          # check if there are no wireless interfaces
          if ! find -H /sys/class/net/* -name wireless | grep -q .; then
            # if so, wait until one appears
            echo "Waiting for wireless interfaces"
            grep -q '^ACTION=add' < <(stdbuf -oL -- udevadm monitor -s net/wlan -pu)
            # Note: the above line has been carefully written:
            # 1. The process substitution avoids udevadm hanging (after grep has quit)
            #    until it tries to write to the pipe again. Not even pipefail works here.
            # 2. stdbuf is needed because udevadm output is buffered by default and grep
            #    may hang until more udev events enter the pipe.
          fi

          # add any interface found to the daemon arguments
          for name in $(find -H /sys/class/net/* -name wireless | cut -d/ -f 5); do
            echo "Adding interface $name"
            args+="''${args:+ -N} -i$name $iface_args"
          done
        '' else ''
          # add known interface to the daemon arguments
          args="-i${iface} $iface_args"
        ''}

        # finally start daemon
        exec wpa_supplicant $args
      '';
    };

  systemctl = "/run/current-system/systemd/bin/systemctl";

in {
  options = {
    networking.wireless = {
      enable = mkEnableOption "wpa_supplicant";

      interfaces = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "wlan0" "wlan1" ];
        description = ''
          The interfaces <command>wpa_supplicant</command> will use. If empty, it will
          automatically use all wireless interfaces.

          <note><para>
            A separate wpa_supplicant instance will be started for each interface.
          </para></note>
        '';
      };

      driver = mkOption {
        type = types.str;
        default = "nl80211,wext";
        description = "Force a specific wpa_supplicant driver.";
      };

      allowAuxiliaryImperativeNetworks = mkEnableOption "support for imperative & declarative networks" // {
        description = ''
          Whether to allow configuring networks "imperatively" (e.g. via
          <package>wpa_supplicant_gui</package>) and declaratively via
          <xref linkend="opt-networking.wireless.networks" />.

          Please note that this adds a custom patch to <package>wpa_supplicant</package>.
        '';
      };

      scanOnLowSignal = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to periodically scan for (better) networks when the signal of
          the current one is low. This will make roaming between access points
          faster, but will consume more power.
        '';
      };

      networks = mkOption {
        type = types.attrsOf (types.submodule {
          options = {
            psk = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = ''
                The network's pre-shared key in plaintext defaulting
                to being a network without any authentication.

                Be aware that these will be written to the nix store
                in plaintext!

                Mutually exclusive with <varname>pskRaw</varname>.
              '';
            };

            pskRaw = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = ''
                The network's pre-shared key in hex defaulting
                to being a network without any authentication.

                Mutually exclusive with <varname>psk</varname>.
              '';
            };

            authProtocols = mkOption {
              default = [
                # WPA2 and WPA3
                "WPA-PSK" "WPA-EAP" "SAE"
                # 802.11r variants of the above
                "FT-PSK" "FT-EAP" "FT-SAE"
              ];
              # The list can be obtained by running this command
              # awk '
              #   /^# key_mgmt: /{ run=1 }
              #   /^#$/{ run=0 }
              #   /^# [A-Z0-9-]{2,}/{ if(run){printf("\"%s\"\n", $2)} }
              # ' /run/current-system/sw/share/doc/wpa_supplicant/wpa_supplicant.conf.example
              type = types.listOf (types.enum [
                "WPA-PSK"
                "WPA-EAP"
                "IEEE8021X"
                "NONE"
                "WPA-NONE"
                "FT-PSK"
                "FT-EAP"
                "FT-EAP-SHA384"
                "WPA-PSK-SHA256"
                "WPA-EAP-SHA256"
                "SAE"
                "FT-SAE"
                "WPA-EAP-SUITE-B"
                "WPA-EAP-SUITE-B-192"
                "OSEN"
                "FILS-SHA256"
                "FILS-SHA384"
                "FT-FILS-SHA256"
                "FT-FILS-SHA384"
                "OWE"
                "DPP"
              ]);
              description = ''
                The list of authentication protocols accepted by this network.
                This corresponds to the <literal>key_mgmt</literal> option in wpa_supplicant.
              '';
            };

            auth = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = ''
                eap=PEAP
                identity="user@example.com"
                password="secret"
              '';
              description = ''
                Use this option to configure advanced authentication methods like EAP.
                See
                <citerefentry>
                  <refentrytitle>wpa_supplicant.conf</refentrytitle>
                  <manvolnum>5</manvolnum>
                </citerefentry>
                for example configurations.

                Mutually exclusive with <varname>psk</varname> and <varname>pskRaw</varname>.
              '';
            };

            hidden = mkOption {
              type = types.bool;
              default = false;
              description = ''
                Set this to <literal>true</literal> if the SSID of the network is hidden.
              '';
              example = literalExample ''
                { echelon = {
                    hidden = true;
                    psk = "abcdefgh";
                  };
                }
              '';
            };

            priority = mkOption {
              type = types.nullOr types.int;
              default = null;
              description = ''
                By default, all networks will get same priority group (0). If some of the
                networks are more desirable, this field can be used to change the order in
                which wpa_supplicant goes through the networks when selecting a BSS. The
                priority groups will be iterated in decreasing priority (i.e., the larger the
                priority value, the sooner the network is matched against the scan results).
                Within each priority group, networks will be selected based on security
                policy, signal strength, etc.
              '';
            };

            extraConfig = mkOption {
              type = types.str;
              default = "";
              example = ''
                bssid_blacklist=02:11:22:33:44:55 02:22:aa:44:55:66
              '';
              description = ''
                Extra configuration lines appended to the network block.
                See
                <citerefentry>
                  <refentrytitle>wpa_supplicant.conf</refentrytitle>
                  <manvolnum>5</manvolnum>
                </citerefentry>
                for available options.
              '';
            };

          };
        });
        description = ''
          The network definitions to automatically connect to when
           <command>wpa_supplicant</command> is running. If this
           parameter is left empty wpa_supplicant will use
          /etc/wpa_supplicant.conf as the configuration file.
        '';
        default = {};
        example = literalExample ''
          { echelon = {                   # SSID with no spaces or special characters
              psk = "abcdefgh";
            };
            "echelon's AP" = {            # SSID with spaces and/or special characters
               psk = "ijklmnop";
            };
            "free.wifi" = {};             # Public wireless network
          }
        '';
      };

      userControlled = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Allow normal users to control wpa_supplicant through wpa_gui or wpa_cli.
            This is useful for laptop users that switch networks a lot and don't want
            to depend on a large package such as NetworkManager just to pick nearby
            access points.

            When using a declarative network specification you cannot persist any
            settings via wpa_gui or wpa_cli.
          '';
        };

        group = mkOption {
          type = types.str;
          default = "wheel";
          example = "network";
          description = "Members of this group can control wpa_supplicant.";
        };
      };

      dbusControlled = mkOption {
        type = types.bool;
        default = lib.length cfg.interfaces < 2;
        description = ''
          Whether to enable the DBus control interface.
          This is only needed when using NetworkManager or connman.
        '';
      };

      extraConfig = mkOption {
        type = types.str;
        default = "";
        example = ''
          p2p_disabled=1
        '';
        description = ''
          Extra lines appended to the configuration file.
          See
          <citerefentry>
            <refentrytitle>wpa_supplicant.conf</refentrytitle>
            <manvolnum>5</manvolnum>
          </citerefentry>
          for available options.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = flip mapAttrsToList cfg.networks (name: cfg: {
      assertion = with cfg; count (x: x != null) [ psk pskRaw auth ] <= 1;
      message = ''options networking.wireless."${name}".{psk,pskRaw,auth} are mutually exclusive'';
    }) ++ [
      {
        assertion = length cfg.interfaces > 1 -> !cfg.dbusControlled;
        message =
          let daemon = if config.networking.networkmanager.enable then "NetworkManager" else
                       if config.services.connman.enable then "connman" else null;
              n = toString (length cfg.interfaces);
          in ''
            It's not possible to run multiple wpa_supplicant instances with DBus support.
            Note: you're seeing this error because `networking.wireless.interfaces` has
            ${n} entries, implying an equal number of wpa_supplicant instances.
          '' + optionalString (daemon != null) ''
            You don't need to change `networking.wireless.interfaces` when using ${daemon}:
            in this case the interfaces will be configured automatically for you.
          '';
      }
    ];

    hardware.wirelessRegulatoryDatabase = true;

    environment.systemPackages = [ package ];
    services.dbus.packages = optional cfg.dbusControlled package;

    systemd.services =
      if cfg.interfaces == []
        then { wpa_supplicant = mkUnit null; }
        else listToAttrs (map (i: nameValuePair "wpa_supplicant-${i}" (mkUnit i)) cfg.interfaces);

    # Restart wpa_supplicant after resuming from sleep
    powerManagement.resumeCommands = concatStringsSep "\n" (
      optional (cfg.interfaces == []) "${systemctl} try-restart wpa_supplicant"
      ++ map (i: "${systemctl} try-restart wpa_supplicant-${i}") cfg.interfaces
    );

    # Restart wpa_supplicant when a wlan device appears or disappears. This is
    # only needed when an interface hasn't been specified by the user.
    services.udev.extraRules = optionalString (cfg.interfaces == []) ''
      ACTION=="add|remove", SUBSYSTEM=="net", ENV{DEVTYPE}=="wlan", \
      RUN+="${systemctl} try-restart wpa_supplicant.service"
    '';
  };

  meta.maintainers = with lib.maintainers; [ globin rnhmjoj ];
}
