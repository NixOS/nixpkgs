{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf mkOption;
  inherit (lib.types) nullOr path bool listOf str;
  keysPath = "/var/lib/yggdrasil/keys.json";

  cfg = config.services.yggdrasil;
  settingsProvided = cfg.settings != { };
  configFileProvided = cfg.configFile != null;

  format = pkgs.formats.json { };
in
{
  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "yggdrasil" "config" ]
      [ "services" "yggdrasil" "settings" ])
  ];

  options = {
    services.yggdrasil = {
      enable = lib.mkEnableOption "the yggdrasil system service";

      settings = mkOption {
        type = format.type;
        default = { };
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
          wish to specify the keys, use {option}`configFile`.

          If the {option}`persistentKeys` is enabled then the
          keys that are generated during activation will override
          those in {option}`settings` or
          {option}`configFile`.

          If no keys are specified then ephemeral keys are generated
          and the Yggdrasil interface will have a random IPv6 address
          each time the service is started. This is the default.

          If both {option}`configFile` and {option}`settings`
          are supplied, they will be combined, with values from
          {option}`configFile` taking precedence.

          You can use the command `nix-shell -p yggdrasil --run "yggdrasil -genconf"`
          to generate default configuration values with documentation.
        '';
      };

      configFile = mkOption {
        type = nullOr path;
        default = null;
        example = "/run/keys/yggdrasil.conf";
        description = ''
          A file which contains JSON or HJSON configuration for yggdrasil. See
          the {option}`settings` option for more information.

          Note: This file must not be larger than 1 MB because it is passed to
          the yggdrasil process via systemd‘s LoadCredential mechanism. For
          details, see <https://systemd.io/CREDENTIALS/> and `man 5
          systemd.exec`.
        '';
      };

      group = mkOption {
        type = nullOr str;
        default = null;
        example = "wheel";
        description = "Group to grant access to the Yggdrasil control socket. If `null`, only root can access the socket.";
      };

      openMulticastPort = mkOption {
        type = bool;
        default = false;
        description = ''
          Whether to open the UDP port used for multicast peer discovery. The
          NixOS firewall blocks link-local communication, so in order to make
          incoming local peering work you will also need to configure
          `MulticastInterfaces` in your Yggdrasil configuration
          ({option}`settings` or {option}`configFile`). You will then have to
          add the ports that you configure there to your firewall configuration
          ({option}`networking.firewall.allowedTCPPorts` or
          {option}`networking.firewall.interfaces.<name>.allowedTCPPorts`).
        '';
      };

      denyDhcpcdInterfaces = mkOption {
        type = listOf str;
        default = [ ];
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

      package = lib.mkPackageOption pkgs "yggdrasil" { };

      persistentKeys = lib.mkEnableOption ''
        persistent keys. If enabled then keys will be generated once and Yggdrasil
        will retain the same IPv6 address when the service is
        restarted. Keys are stored at ${keysPath}
      '';

      extraArgs = mkOption {
        type = listOf str;
        default = [ ];
        example = [ "-loglevel" "info" ];
        description = "Extra command line arguments.";
      };

    };
  };

  config = mkIf cfg.enable (
    let
      binYggdrasil = "${cfg.package}/bin/yggdrasil";
      binHjson = "${pkgs.hjson-go}/bin/hjson-cli";
    in
    {
      assertions = [{
        assertion = config.networking.enableIPv6;
        message = "networking.enableIPv6 must be true for yggdrasil to work";
      }];

      # This needs to be a separate service. The yggdrasil service fails if
      # this is put into its preStart.
      systemd.services.yggdrasil-persistent-keys = lib.mkIf cfg.persistentKeys {
        wantedBy = [ "multi-user.target" ];
        before = [ "yggdrasil.service" ];
        serviceConfig.Type = "oneshot";
        serviceConfig.RemainAfterExit = true;
        script = ''
          if [ ! -e ${keysPath} ]
          then
            mkdir --mode=700 -p ${builtins.dirOf keysPath}
            ${binYggdrasil} -genconf -json \
              | ${pkgs.jq}/bin/jq \
                  'to_entries|map(select(.key|endswith("Key")))|from_entries' \
              > ${keysPath}
          fi
        '';
      };

      systemd.services.yggdrasil = {
        description = "Yggdrasil Network Service";
        after = [ "network-pre.target" ];
        wants = [ "network.target" ];
        before = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        # This script first prepares the config file, then it starts Yggdrasil.
        # The preparation could also be done in ExecStartPre/preStart but only
        # systemd versions >= v252 support reading credentials in ExecStartPre. As
        # of February 2023, systemd v252 is not yet in the stable branch of NixOS.
        #
        # This could be changed in the future once systemd version v252 has
        # reached NixOS but it does not have to be. Config file preparation is
        # fast enough, it does not need elevated privileges, and `set -euo
        # pipefail` should make sure that the service is not started if the
        # preparation fails. Therefore, it is not necessary to move the
        # preparation to ExecStartPre.
        script = ''
          set -euo pipefail

          # prepare config file
          ${(if settingsProvided || configFileProvided || cfg.persistentKeys then
            "echo "

            + (lib.optionalString settingsProvided
              "'${builtins.toJSON cfg.settings}'")
            + (lib.optionalString configFileProvided
              "$(${binHjson} -c \"$CREDENTIALS_DIRECTORY/yggdrasil.conf\")")
            + (lib.optionalString cfg.persistentKeys "$(cat ${keysPath})")
            + " | ${pkgs.jq}/bin/jq -s add | ${binYggdrasil} -normaliseconf -useconf"
          else
            "${binYggdrasil} -genconf") + " > /run/yggdrasil/yggdrasil.conf"}

          # start yggdrasil
          ${binYggdrasil} -useconffile /run/yggdrasil/yggdrasil.conf ${lib.strings.escapeShellArgs cfg.extraArgs}
        '';

        serviceConfig = {
          ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
          Restart = "always";

          DynamicUser = true;
          StateDirectory = "yggdrasil";
          RuntimeDirectory = "yggdrasil";
          RuntimeDirectoryMode = "0750";
          BindReadOnlyPaths = lib.optional cfg.persistentKeys keysPath;
          LoadCredential =
            mkIf configFileProvided "yggdrasil.conf:${cfg.configFile}";

          AmbientCapabilities = "CAP_NET_ADMIN CAP_NET_BIND_SERVICE";
          CapabilityBoundingSet = "CAP_NET_ADMIN CAP_NET_BIND_SERVICE";
          MemoryDenyWriteExecute = true;
          ProtectControlGroups = true;
          ProtectHome = "tmpfs";
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6 AF_NETLINK";
          RestrictNamespaces = true;
          RestrictRealtime = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [ "@system-service" "~@privileged @keyring" ];
        } // (if (cfg.group != null) then {
          Group = cfg.group;
        } else { });
      };

      networking.dhcpcd.denyInterfaces = cfg.denyDhcpcdInterfaces;
      networking.firewall.allowedUDPPorts = mkIf cfg.openMulticastPort [ 9001 ];

      # Make yggdrasilctl available on the command line.
      environment.systemPackages = [ cfg.package ];
    }
  );
  meta = {
    doc = ./yggdrasil.md;
    maintainers = with lib.maintainers; [ gazally ehmry nagy ];
  };
}
