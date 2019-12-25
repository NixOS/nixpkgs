{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.yggdrasil;
  configProvided = (cfg.config != {});
  configAsFile = (if configProvided then
                   toString (pkgs.writeTextFile {
                     name = "yggdrasil-conf";
                     text = builtins.toJSON cfg.config;
                   })
                   else null);
  configFileProvided = (cfg.configFile != null);
  generateConfig = (
    if configProvided && configFileProvided then
      "${pkgs.jq}/bin/jq -s add ${configAsFile} ${cfg.configFile}"
    else if configProvided then
      "cat ${configAsFile}"
    else if configFileProvided then
      "cat ${cfg.configFile}"
    else
      "${cfg.package}/bin/yggdrasil -genconf"
  );

in {
  options = with types; {
    services.yggdrasil = {
      enable = mkEnableOption "the yggdrasil system service";

      configFile = mkOption {
        type =  nullOr str;
        default = null;
        example = "/run/keys/yggdrasil.conf";
        description = ''
          A file which contains JSON configuration for yggdrasil.

          You do not have to supply a complete configuration, as
          yggdrasil will use default values for anything which is
          omitted.  If the encryption and signing keys are omitted,
          yggdrasil will generate new ones each time the service is
          started, resulting in a random IPv6 address on the yggdrasil
          network each time.

          If both this option and <option>config</option> are
          supplied, they will be combined, with values from
          <option>config</option> taking precedence.

          You can use the command <code>nix-shell -p yggdrasil --run
          "yggdrasil -genconf -json"</code> to generate a default
          JSON configuration.
        '';
      };

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
          Therefore, it is not appropriate for private keys.  If you
          do not specify the keys, yggdrasil will generate a new set
          each time the service is started, creating a random IPv6
          address on the yggdrasil network each time.

          If you wish to specify the keys, use
          <option>configFile</option>.  If both
          <option>configFile</option> and <option>config</option> are
          supplied, they will be combined, with values from
          <option>config</option> taking precedence.

          You can use the command <code>nix-shell -p yggdrasil --run
          "yggdrasil -genconf"</code> to generate default
          configuration values with documentation.
        '';
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
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      { assertion = config.networking.enableIPv6;
        message = "networking.enableIPv6 must be true for yggdrasil to work";
      }
    ];

    systemd.services.yggdrasil = {
      description = "Yggdrasil Network Service";
      path = [ cfg.package ] ++ optional (configProvided && configFileProvided) pkgs.jq;
      bindsTo = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        ${generateConfig} | yggdrasil -normaliseconf -useconf > /run/yggdrasil/yggdrasil.conf
      '';

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/yggdrasil -useconffile /run/yggdrasil/yggdrasil.conf";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        Restart = "always";

        RuntimeDirectory = "yggdrasil";
        RuntimeDirectoryMode = "0700";
        BindReadOnlyPaths = mkIf configFileProvided
          [ "${cfg.configFile}" ];

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
  };
  meta.maintainers = with lib.maintainers; [ gazally ];
}
