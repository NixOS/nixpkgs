{ config, lib, pkgs, ... }:
with lib;
let
  keysPath = "/var/lib/yggdrasil/keys.json";

  cfg = config.services.yggdrasil;
  configProvided = cfg.config != { };
  configFileProvided = cfg.configFile != null;

in {
  options = with types; {
    services.yggdrasil = {
      enable = mkEnableOption "the yggdrasil system service";

      config = mkOption {
        type = attrs;
        default = {};
        example = {
          Peers = [
            "tcp://aa.bb.cc.dd:eeeee"
            "tcp://[aaaa:bbbb:cccc:dddd::eeee]:fffff"
          ];
          Listen = [
            "tcp://0.0.0.0:xxxxx"
          ];
        };
        description = ''
          Configuration for yggdrasil, as a Nix attribute set.

          Warning: this is stored in the WORLD-READABLE Nix store!
          Therefore, it is not appropriate for private keys. If you
          wish to specify the keys, use <option>configFile</option>.

          If the <option>persistentKeys</option> is enabled then the
          keys that are generated during activation will override
          those in <option>config</option> or
          <option>configFile</option>.

          If no keys are specified then ephemeral keys are generated
          and the Yggdrasil interface will have a random IPv6 address
          each time the service is started, this is the default.

          If both <option>configFile</option> and <option>config</option>
          are supplied, they will be combined, with values from
          <option>configFile</option> taking precedence.

          You can use the command <code>nix-shell -p yggdrasil --run
          "yggdrasil -genconf"</code> to generate default
          configuration values with documentation.
        '';
      };

      configFile = mkOption {
        type = nullOr path;
        default = null;
        example = "/run/keys/yggdrasil.conf";
        description = ''
          A file which contains JSON configuration for yggdrasil.
          See the <option>config</option> option for more information.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "root";
        example = "wheel";
        description = "Group to grant acces to the Yggdrasil control socket.";
      };

      openMulticastPort = mkOption {
        type = bool;
        default = false;
        description = ''
          Whether to open the UDP port used for multicast peer
          discovery. The NixOS firewall blocks link-local
          communication, so in order to make local peering work you
          will also need to set <code>LinkLocalTCPPort</code> in your
          yggdrasil configuration (<option>config</option> or
          <option>configFile</option>) to a port number other than 0,
          and then add that port to
          <option>networking.firewall.allowedTCPPorts</option>.
        '';
      };

      denyDhcpcdInterfaces = mkOption {
        type = listOf str;
        default = [];
        example = [ "tap*" ];
        description = ''
          Disable the DHCP client for any interface whose name matches
          any of the shell glob patterns in this list.  Use this
          option to prevent the DHCP client from broadcasting requests
          on the yggdrasil network.  It is only necessary to do so
          when yggdrasil is running in TAP mode, because TUN
          interfaces do not support broadcasting.
        '';
      };

      package = mkOption {
        type = package;
        default = pkgs.yggdrasil;
        defaultText = "pkgs.yggdrasil";
        description = "Yggdrasil package to use.";
      };

      persistentKeys = mkEnableOption ''
        If enabled then keys will be generated once and Yggdrasil
        will retain the same IPv6 address when the service is
        restarted. Keys are stored at ${keysPath}.
      '';

    };
  };

  config = mkIf cfg.enable (let binYggdrasil = cfg.package + "/bin/yggdrasil";
  in {
    assertions = [{
      assertion = config.networking.enableIPv6;
      message = "networking.enableIPv6 must be true for yggdrasil to work";
    }];

    system.activationScripts.yggdrasil = mkIf cfg.persistentKeys ''
      if [ ! -e ${keysPath} ]
      then
        mkdir -p ${builtins.dirOf keysPath}
        ${binYggdrasil} -genconf -json \
          | ${pkgs.jq}/bin/jq \
              'to_entries|map(select(.key|endswith("Key")))|from_entries' \
          > ${keysPath}
        chmod 600 ${keysPath}
      fi
    '';

    systemd.services.yggdrasil = {
      description = "Yggdrasil Network Service";
      bindsTo = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart =
        (if configProvided || configFileProvided || cfg.persistentKeys then
          "echo "

          + (lib.optionalString configProvided
            "'${builtins.toJSON cfg.config}'")
          + (lib.optionalString configFileProvided "$(cat ${cfg.configFile})")
          + (lib.optionalString cfg.persistentKeys "$(cat ${keysPath})")
          + " | ${pkgs.jq}/bin/jq -s add | ${binYggdrasil} -normaliseconf -useconf"
        else
          "${binYggdrasil} -genconf") + " > /run/yggdrasil/yggdrasil.conf";

      serviceConfig = {
        ExecStart =
          "${binYggdrasil} -useconffile /run/yggdrasil/yggdrasil.conf";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        Restart = "always";

        Group = cfg.group;
        RuntimeDirectory = "yggdrasil";
        RuntimeDirectoryMode = "0750";
        BindReadOnlyPaths = lib.optional configFileProvided cfg.configFile
          ++ lib.optional cfg.persistentKeys keysPath;

        # TODO: as of yggdrasil 0.3.8 and systemd 243, yggdrasil fails
        # to set up the network adapter when DynamicUser is set.  See
        # github.com/yggdrasil-network/yggdrasil-go/issues/557.  The
        # following options are implied by DynamicUser according to
        # the systemd.exec documentation, and can be removed if the
        # upstream issue is fixed and DynamicUser is set to true:
        PrivateTmp = true;
        RemoveIPC = true;
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        RestrictSUIDSGID = true;
        # End of list of options implied by DynamicUser.

        AmbientCapabilities = "CAP_NET_ADMIN";
        CapabilityBoundingSet = "CAP_NET_ADMIN";
        MemoryDenyWriteExecute = true;
        ProtectControlGroups = true;
        ProtectHome = "tmpfs";
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6 AF_NETLINK";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = "~@clock @cpu-emulation @debug @keyring @module @mount @obsolete @raw-io @resources";
      };
    };

    networking.dhcpcd.denyInterfaces = cfg.denyDhcpcdInterfaces;
    networking.firewall.allowedUDPPorts = mkIf cfg.openMulticastPort [ 9001 ];

    # Make yggdrasilctl available on the command line.
    environment.systemPackages = [ cfg.package ];
  });
  meta = {
    doc = ./yggdrasil.xml;
    maintainers = with lib.maintainers; [ gazally ehmry ];
  };
}
