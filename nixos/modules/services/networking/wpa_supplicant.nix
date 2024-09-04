{ config, lib, options, pkgs, utils, ... }:
let
  cfg = config.networking.wireless;
  opt = options.networking.wireless;

  wpa3Protocols = [ "SAE" "FT-SAE" ];
  hasMixedWPA = opts:
    let
      hasWPA3 = !lib.mutuallyExclusive opts.authProtocols wpa3Protocols;
      others = lib.subtractLists wpa3Protocols opts.authProtocols;
    in hasWPA3 && others != [];

  # Gives a WPA3 network higher priority
  increaseWPA3Priority = opts:
    opts // lib.optionalAttrs (hasMixedWPA opts)
      { priority = if opts.priority == null
                     then 1
                     else opts.priority + 1;
      };

  # Creates a WPA2 fallback network
  mkWPA2Fallback = opts:
    opts // { authProtocols = lib.subtractLists wpa3Protocols opts.authProtocols; };

  # Networks attrset as a list
  networkList = lib.mapAttrsToList (ssid: opts: opts // { inherit ssid; })
                cfg.networks;

  # List of all networks (normal + generated fallbacks)
  allNetworks =
    if cfg.fallbackToWPA2
      then map increaseWPA3Priority networkList
           ++ map mkWPA2Fallback (lib.filter hasMixedWPA networkList)
      else networkList;

  # Content of wpa_supplicant.conf
  generatedConfig = lib.concatStringsSep "\n" (
    (map mkNetwork allNetworks)
    ++ lib.optional cfg.userControlled.enable (lib.concatStringsSep "\n"
      [ "ctrl_interface=/run/wpa_supplicant"
        "ctrl_interface_group=${cfg.userControlled.group}"
        "update_config=1"
      ])
    ++ [ "pmf=1" ]
    ++ lib.optional cfg.scanOnLowSignal ''bgscan="simple:30:-70:3600"''
    ++ lib.optional (cfg.extraConfig != "") cfg.extraConfig);

  configIsGenerated = with cfg;
    networks != {} || extraConfig != "" || userControlled.enable;

  # the original configuration file
  configFile =
    if configIsGenerated
      then pkgs.writeText "wpa_supplicant.conf" generatedConfig
      else "/etc/wpa_supplicant.conf";
  # the config file with environment variables replaced
  finalConfig = ''"$RUNTIME_DIRECTORY"/wpa_supplicant.conf'';

  # Creates a network block for wpa_supplicant.conf
  mkNetwork = opts:
  let
    quote = x: ''"${x}"'';
    indent = x: "  " + x;

    pskString = if opts.psk != null
      then quote opts.psk
      else opts.pskRaw;

    options = [
      "ssid=${quote opts.ssid}"
      (if pskString != null || opts.auth != null
        then "key_mgmt=${lib.concatStringsSep " " opts.authProtocols}"
        else "key_mgmt=NONE")
    ] ++ lib.optional opts.hidden "scan_ssid=1"
      ++ lib.optional (pskString != null) "psk=${pskString}"
      ++ lib.optionals (opts.auth != null) (lib.filter (x: x != "") (lib.splitString "\n" opts.auth))
      ++ lib.optional (opts.priority != null) "priority=${toString opts.priority}"
      ++ lib.optional (opts.extraConfig != "") opts.extraConfig;
  in ''
    network={
    ${lib.concatMapStringsSep "\n" indent options}
    }
  '';

  # Creates a systemd unit for wpa_supplicant bound to a given (or any) interface
  mkUnit = iface:
    let
      deviceUnit = lib.optional (iface != null) "sys-subsystem-net-devices-${utils.escapeSystemdPath iface}.device";
      configStr = if cfg.allowAuxiliaryImperativeNetworks
        then "-c /etc/wpa_supplicant.conf -I ${finalConfig}"
        else "-c ${finalConfig}";
    in {
      description = "WPA Supplicant instance" + lib.optionalString (iface != null) " for interface ${iface}";

      after = deviceUnit;
      before = [ "network.target" ];
      wants = [ "network.target" ];
      requires = deviceUnit;
      wantedBy = [ "multi-user.target" ];
      stopIfChanged = false;

      path = [ pkgs.wpa_supplicant ];
      # if `userControl.enable`, the supplicant automatically changes the permissions
      #  and owning group of the runtime dir; setting `umask` ensures the generated
      #  config file isn't readable (except to root);  see nixpkgs#267693
      serviceConfig.UMask = "066";
      serviceConfig.RuntimeDirectory = "wpa_supplicant";
      serviceConfig.RuntimeDirectoryMode = "700";
      serviceConfig.EnvironmentFile = lib.mkIf (cfg.environmentFile != null)
        (builtins.toString cfg.environmentFile);

      script =
      ''
        ${lib.optionalString (configIsGenerated && !cfg.allowAuxiliaryImperativeNetworks) ''
          if [ -f /etc/wpa_supplicant.conf ]; then
            echo >&2 "<3>/etc/wpa_supplicant.conf present but ignored. Generated ${configFile} is used instead."
          fi
        ''}

        # ensure wpa_supplicant.conf exists, or the daemon will fail to start
        ${lib.optionalString cfg.allowAuxiliaryImperativeNetworks ''
          touch /etc/wpa_supplicant.conf
        ''}

        # substitute environment variables
        if [ -f "${configFile}" ]; then
          ${pkgs.gawk}/bin/awk '{
            for(varname in ENVIRON) {
              find = "@"varname"@"
              repl = ENVIRON[varname]
              if (i = index($0, find))
                $0 = substr($0, 1, i-1) repl substr($0, i+length(find))
            }
            print
          }' "${configFile}" > ${finalConfig}
        else
          touch ${finalConfig}
        fi

        iface_args="-s ${lib.optionalString cfg.dbusControlled "-u"} -D${cfg.driver} ${configStr}"

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
      enable = lib.mkEnableOption "wpa_supplicant";

      interfaces = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        example = [ "wlan0" "wlan1" ];
        description = ''
          The interfaces {command}`wpa_supplicant` will use. If empty, it will
          automatically use all wireless interfaces.

          ::: {.note}
          A separate wpa_supplicant instance will be started for each interface.
          :::
        '';
      };

      driver = lib.mkOption {
        type = lib.types.str;
        default = "nl80211,wext";
        description = "Force a specific wpa_supplicant driver.";
      };

      allowAuxiliaryImperativeNetworks = lib.mkEnableOption "support for imperative & declarative networks" // {
        description = ''
          Whether to allow configuring networks "imperatively" (e.g. via
          `wpa_supplicant_gui`) and declaratively via
          [](#opt-networking.wireless.networks).

          Please note that this adds a custom patch to `wpa_supplicant`.
        '';
      };

      scanOnLowSignal = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to periodically scan for (better) networks when the signal of
          the current one is low. This will make roaming between access points
          faster, but will consume more power.
        '';
      };

      fallbackToWPA2 = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to fall back to WPA2 authentication protocols if WPA3 failed.
          This allows old wireless cards (that lack recent features required by
          WPA3) to connect to mixed WPA2/WPA3 access points.

          To avoid possible downgrade attacks, disable this options.
        '';
      };

      environmentFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/run/secrets/wireless.env";
        description = ''
          File consisting of lines of the form `varname=value`
          to define variables for the wireless configuration.

          See section "EnvironmentFile=" in {manpage}`systemd.exec(5)` for a syntax reference.

          Secrets (PSKs, passwords, etc.) can be provided without adding them to
          the world-readable Nix store by defining them in the environment file and
          referring to them in option {option}`networking.wireless.networks`
          with the syntax `@varname@`. Example:

          ```
          # content of /run/secrets/wireless.env
          PSK_HOME=mypassword
          PASS_WORK=myworkpassword
          ```

          ```
          # wireless-related configuration
          networking.wireless.environmentFile = "/run/secrets/wireless.env";
          networking.wireless.networks = {
            home.psk = "@PSK_HOME@";
            work.auth = '''
              eap=PEAP
              identity="my-user@example.com"
              password="@PASS_WORK@"
            ''';
          };
          ```
        '';
      };

      networks = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule {
          options = {
            psk = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = ''
                The network's pre-shared key in plaintext defaulting
                to being a network without any authentication.

                ::: {.warning}
                Be aware that this will be written to the nix store
                in plaintext! Use an environment variable instead.
                :::

                ::: {.note}
                Mutually exclusive with {var}`pskRaw`.
                :::
              '';
            };

            pskRaw = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = ''
                The network's pre-shared key in hex defaulting
                to being a network without any authentication.

                ::: {.warning}
                Be aware that this will be written to the nix store
                in plaintext! Use an environment variable instead.
                :::

                ::: {.note}
                Mutually exclusive with {var}`psk`.
                :::
              '';
            };

            authProtocols = lib.mkOption {
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
              type = lib.types.listOf (lib.types.enum [
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
                This corresponds to the `key_mgmt` option in wpa_supplicant.
              '';
            };

            auth = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              example = ''
                eap=PEAP
                identity="user@example.com"
                password="@EXAMPLE_PASSWORD@"
              '';
              description = ''
                Use this option to configure advanced authentication methods like EAP.
                See
                {manpage}`wpa_supplicant.conf(5)`
                for example configurations.

                ::: {.warning}
                Be aware that this will be written to the nix store
                in plaintext! Use an environment variable for secrets.
                :::

                ::: {.note}
                Mutually exclusive with {var}`psk` and
                {var}`pskRaw`.
                :::
              '';
            };

            hidden = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Set this to `true` if the SSID of the network is hidden.
              '';
              example = lib.literalExpression ''
                { echelon = {
                    hidden = true;
                    psk = "abcdefgh";
                  };
                }
              '';
            };

            priority = lib.mkOption {
              type = lib.types.nullOr lib.types.int;
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

            extraConfig = lib.mkOption {
              type = lib.types.str;
              default = "";
              example = ''
                bssid_blacklist=02:11:22:33:44:55 02:22:aa:44:55:66
              '';
              description = ''
                Extra configuration lines appended to the network block.
                See
                {manpage}`wpa_supplicant.conf(5)`
                for available options.
              '';
            };

          };
        });
        description = ''
          The network definitions to automatically connect to when
           {command}`wpa_supplicant` is running. If this
           parameter is left empty wpa_supplicant will use
          /etc/wpa_supplicant.conf as the configuration file.
        '';
        default = {};
        example = lib.literalExpression ''
          { echelon = {                   # SSID with no spaces or special characters
              psk = "abcdefgh";           # (password will be written to /nix/store!)
            };

            echelon = {                   # safe version of the above: read PSK from the
              psk = "@PSK_ECHELON@";      # variable PSK_ECHELON, defined in environmentFile,
            };                            # this won't leak into /nix/store

            "echelon's AP" = {            # SSID with spaces and/or special characters
               psk = "ijklmnop";          # (password will be written to /nix/store!)
            };

            "free.wifi" = {};             # Public wireless network
          }
        '';
      };

      userControlled = {
        enable = lib.mkOption {
          type = lib.types.bool;
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

        group = lib.mkOption {
          type = lib.types.str;
          default = "wheel";
          example = "network";
          description = "Members of this group can control wpa_supplicant.";
        };
      };

      dbusControlled = lib.mkOption {
        type = lib.types.bool;
        default = lib.length cfg.interfaces < 2;
        defaultText = lib.literalExpression "lib.length config.${opt.interfaces} < 2";
        description = ''
          Whether to enable the DBus control interface.
          This is only needed when using NetworkManager or connman.
        '';
      };

      extraConfig = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = ''
          p2p_disabled=1
        '';
        description = ''
          Extra lines appended to the configuration file.
          See
          {manpage}`wpa_supplicant.conf(5)`
          for available options.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = lib.flip lib.mapAttrsToList cfg.networks (name: cfg: {
      assertion = with cfg; count (x: x != null) [ psk pskRaw auth ] <= 1;
      message = ''options networking.wireless."${name}".{psk,pskRaw,auth} are mutually exclusive'';
    }) ++ [
      {
        assertion = lib.length cfg.interfaces > 1 -> !cfg.dbusControlled;
        message =
          let daemon = if config.networking.networkmanager.enable then "NetworkManager" else
                       if config.services.connman.enable then "connman" else null;
              n = toString (lib.length cfg.interfaces);
          in ''
            It's not possible to run multiple wpa_supplicant instances with DBus support.
            Note: you're seeing this error because `networking.wireless.interfaces` has
            ${n} entries, implying an equal number of wpa_supplicant instances.
          '' + lib.optionalString (daemon != null) ''
            You don't need to change `networking.wireless.interfaces` when using ${daemon}:
            in this case the interfaces will be configured automatically for you.
          '';
      }
    ];

    hardware.wirelessRegulatoryDatabase = true;

    environment.systemPackages = [ pkgs.wpa_supplicant ];
    services.dbus.packages = lib.optional cfg.dbusControlled pkgs.wpa_supplicant;

    systemd.services =
      if cfg.interfaces == []
        then { wpa_supplicant = mkUnit null; }
        else lib.listToAttrs (map (i: lib.nameValuePair "wpa_supplicant-${i}" (mkUnit i)) cfg.interfaces);

    # Restart wpa_supplicant after resuming from sleep
    powerManagement.resumeCommands = lib.concatStringsSep "\n" (
      lib.optional (cfg.interfaces == []) "${systemctl} try-restart wpa_supplicant"
      ++ map (i: "${systemctl} try-restart wpa_supplicant-${i}") cfg.interfaces
    );

    # Restart wpa_supplicant when a wlan device appears or disappears. This is
    # only needed when an interface hasn't been specified by the user.
    services.udev.extraRules = lib.optionalString (cfg.interfaces == []) ''
      ACTION=="add|remove", SUBSYSTEM=="net", ENV{DEVTYPE}=="wlan", \
      RUN+="${systemctl} try-restart wpa_supplicant.service"
    '';
  };

  meta.maintainers = with lib.maintainers; [ rnhmjoj ];
}
