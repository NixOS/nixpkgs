{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.options) mkOption mkPackageOption mkEnableOption;
  inherit (lib.lists) optional optionals;
  inherit (lib.strings)
    hasSuffix
    escapeShellArgs
    ;
  inherit (lib) types;
  cfg = config.services.vwifi;
in
{
  options = {
    services.vwifi =
      let
        mkOptionalPort =
          name:
          mkOption {
            description = ''
              The ${name} port. Set to null if we should leave it unset.
            '';
            type = with types; nullOr port;
            default = null;
          };
      in
      {
        package = mkPackageOption pkgs "vwifi" { };
        module = {
          enable = mkEnableOption "mac80211_hwsim module";
          numRadios = mkOption {
            description = "The number of virtual radio interfaces to create.";
            type = types.int;
            default = 1;
          };
          macPrefix = mkOption {
            description = ''
              The prefix for MAC addresses to use, without the trailing ':'.
              If one radio is created, you can specify the whole MAC address here.
              The default is defined in vwifi/src/config.h.
            '';
            type = types.strMatching "^(([0-9A-Fa-f]{2}:){0,5}[0-9A-Fa-f]{2})$";
            default = "74:F8:F6";
          };
        };
        client = {
          enable = mkEnableOption "vwifi client";
          spy = mkEnableOption "spy mode, useful for wireless monitors";
          serverAddress = mkOption {
            description = ''
              The address of the server. If set to null, will try to use the vsock protocol.
              Note that this assumes that the server is spawned on the host and passed through to
              QEMU, with something like:

              -device vhost-vsock-pci,id=vwifi0,guest-cid=42
            '';
            type = with types; nullOr str;
            default = null;
          };
          serverPort = mkOptionalPort "server port";
          extraArgs = mkOption {
            description = ''
              Extra arguments to pass to vwifi-client. You can use this if you want to bring
              the radios up using vwifi-client instead of at boot.
            '';
            type = with types; listOf str;
            default = [ ];
            example = [
              "--number"
              "3"
            ];
          };
        };
        server = {
          enable = mkEnableOption "vwifi server";
          vsock.enable = mkEnableOption "vsock kernel module";
          ports = {
            vhost = mkOptionalPort "vhost";
            tcp = mkOptionalPort "TCP server";
            spy = mkOptionalPort "spy interface";
            control = mkOptionalPort "control interface";
          };
          openFirewall = mkEnableOption "opening the firewall for the TCP and spy ports";
          extraArgs = mkOption {
            description = ''
              Extra arguments to pass to vwifi-server. You can use this for things including
              changing the ports or inducing packet loss.
            '';
            type = with types; listOf str;
            default = [ ];
            example = [ "--lost-packets" ];
          };
        };
      };
  };

  config = mkMerge [
    (mkIf cfg.module.enable {
      boot.kernelModules = [
        "mac80211_hwsim"
      ];
      boot.extraModprobeConfig = ''
        # We'll add more radios using vwifi-add-interfaces in the systemd unit.
        options mac80211_hwsim radios=0
      '';
      systemd.services.vwifi-add-interfaces = mkIf (cfg.module.numRadios > 0) {
        description = "vwifi interface bringup";
        wantedBy = [ "network-pre.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart =
            let
              args = [
                (toString cfg.module.numRadios)
                cfg.module.macPrefix
              ];
            in
            "${cfg.package}/bin/vwifi-add-interfaces ${escapeShellArgs args}";
        };
      };
      assertions = [
        {
          assertion = !(hasSuffix ":" cfg.module.macPrefix);
          message = ''
            services.vwifi.module.macPrefix should not have a trailing ":".
          '';
        }
      ];
    })
    (mkIf cfg.client.enable {
      systemd.services.vwifi-client =
        let
          clientArgs =
            optional cfg.client.spy "--spy"
            ++ optional (cfg.client.serverAddress != null) cfg.client.serverAddress
            ++ optionals (cfg.client.serverPort != null) [
              "--port"
              cfg.client.serverPort
            ]
            ++ cfg.client.extraArgs;
        in
        rec {
          description = "vwifi client";
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];
          requires = after;
          serviceConfig = {
            ExecStart = "${cfg.package}/bin/vwifi-client ${escapeShellArgs clientArgs}";
          };
        };
    })
    (mkIf cfg.server.enable {
      boot.kernelModules = mkIf cfg.server.vsock.enable [
        "vhost_vsock"
      ];
      networking.firewall.allowedTCPPorts = mkIf cfg.server.openFirewall (
        optional (cfg.server.ports.tcp != null) cfg.server.ports.tcp
        ++ optional (cfg.server.ports.spy != null) cfg.server.ports.spy
      );
      systemd.services.vwifi-server =
        let
          serverArgs =
            optionals (cfg.server.ports.vhost != null) [
              "--port-vhost"
              (toString cfg.server.ports.vhost)
            ]
            ++ optionals (cfg.server.ports.tcp != null) [
              "--port-tcp"
              (toString cfg.server.ports.tcp)
            ]
            ++ optionals (cfg.server.ports.spy != null) [
              "--port-spy"
              (toString cfg.server.ports.spy)
            ]
            ++ optionals (cfg.server.ports.control != null) [
              "--port-ctrl"
              (toString cfg.server.ports.control)
            ]
            ++ cfg.server.extraArgs;
        in
        rec {
          description = "vwifi server";
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];
          requires = after;
          serviceConfig = {
            ExecStart = "${cfg.package}/bin/vwifi-server ${escapeShellArgs serverArgs}";
          };
        };
    })
  ];

  meta.maintainers = with lib.maintainers; [ numinit ];
}
