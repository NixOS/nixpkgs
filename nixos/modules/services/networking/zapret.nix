{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.zapret;

  whitelist = lib.optionalString (
    (builtins.length cfg.whitelist) != 0
  ) "--hostlist ${pkgs.writeText "zapret-whitelist" (lib.concatStringsSep "\n" cfg.whitelist)}";

  blacklist =
    lib.optionalString ((builtins.length cfg.blacklist) != 0)
      "--hostlist-exclude ${pkgs.writeText "zapret-blacklist" (lib.concatStringsSep "\n" cfg.blacklist)}";

  params = lib.concatStringsSep " " cfg.params;

  qnum = toString cfg.qnum;
in
{
  options.services.zapret = {
    enable = lib.mkEnableOption "the Zapret DPI bypass service.";
    package = lib.mkPackageOption pkgs "zapret" { };
    params = lib.mkOption {
      default = [ ];
      type = with lib.types; listOf str;
      example = [
        "--dpi-desync=fake,disorder2"
        "--dpi-desync-ttl=1"
        "--dpi-desync-autottl=2"
      ];
      description = ''
        Specify the bypass parameters for Zapret binary.
        There are no universal parameters as they vary between different networks, so you'll have to find them yourself.

        This can be done by running the `blockcheck` binary from zapret package, i.e. `nix-shell -p nftables zapret --command blockcheck` (or `iptables` instead of `nftables` if that is what your firewall is using).
        It'll try different params and then tell you which params are working for your network.
      '';
    };
    whitelist = lib.mkOption {
      default = [ ];
      type = with lib.types; listOf str;
      example = [
        "youtube.com"
        "googlevideo.com"
        "ytimg.com"
        "youtu.be"
      ];
      description = ''
        Specify a list of domains to bypass. All other domains will be ignored.
        You can specify either whitelist or blacklist, but not both.
        If neither are specified, then bypass all domains.

        It is recommended to specify the whitelist. This will make sure that other resources won't be affected by this service.
      '';
    };
    blacklist = lib.mkOption {
      default = [ ];
      type = with lib.types; listOf str;
      example = [
        "example.com"
      ];
      description = ''
        Specify a list of domains NOT to bypass. All other domains will be bypassed.
        You can specify either whitelist or blacklist, but not both.
        If neither are specified, then bypass all domains.
      '';
    };
    qnum = lib.mkOption {
      default = 200;
      type = lib.types.int;
      description = ''
        Routing queue number.
        Only change this if you already use the default queue number somewhere else.
      '';
    };
    configureFirewall = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = ''
        Whether to setup firewall routing so that system http(s) traffic is forwarded via this service.
        Disable if you want to set it up manually.
      '';
    };
    httpSupport = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = ''
        Whether to route http traffic on port 80.
        Http bypass rarely works and you might want to disable it if you don't utilise http connections.
      '';
    };
    httpMode = lib.mkOption {
      default = "first";
      type = lib.types.enum [
        "first"
        "full"
      ];
      example = "full";
      description = ''
        By default this service only changes the first packet sent, which is enough in most cases.
        But there are DPIs that monitor the whole traffic within a session.
        That requires full processing of every packet, which increases the CPU usage.

        Set the mode to `full` if http doesn't work.
      '';
    };
    udpSupport = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        Enable UDP routing.
        This requires you to specify `udpPorts` and `--dpi-desync-any-protocol` parameter.
      '';
    };
    udpPorts = lib.mkOption {
      default = [ ];
      type = with lib.types; listOf str;
      example = [
        "50000:50099"
        "1234"
      ];
      description = ''
        List of UDP ports to route.
        Port ranges are delimited with a colon like this "50000:50099".
      '';
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        assertions = [
          {
            assertion = (builtins.length cfg.whitelist) == 0 || (builtins.length cfg.blacklist) == 0;
            message = "Can't specify both whitelist and blacklist.";
          }
          {
            assertion = (builtins.length cfg.params) != 0;
            message = "You have to specify zapret parameters. See the params option's description.";
          }
          {
            assertion = cfg.udpSupport -> (builtins.length cfg.udpPorts) != 0;
            message = "You have to specify UDP ports or disable UDP support.";
          }
          {
            assertion = !cfg.configureFirewall || !config.networking.nftables.enable;
            message = "You need to manually configure you firewall for Zapret service when using nftables.";
          }
        ];

        systemd.services.zapret = {
          description = "DPI bypass service";
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];
          serviceConfig = {
            ExecStart = "${cfg.package}/bin/nfqws --pidfile=/run/nfqws.pid ${params} ${whitelist} ${blacklist} --qnum=${qnum}";
            Type = "simple";
            PIDFile = "/run/nfqws.pid";
            Restart = "always";
            RuntimeMaxSec = "1h"; # This service loves to crash silently or cause network slowdowns. It also restarts instantly. Restarting it at least hourly provided the best experience.

            # Hardening.
            DevicePolicy = "closed";
            KeyringMode = "private";
            PrivateTmp = true;
            PrivateMounts = true;
            ProtectHome = true;
            ProtectHostname = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            ProtectSystem = "strict";
            ProtectProc = "invisible";
            RemoveIPC = true;
            RestrictNamespaces = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;
            SystemCallArchitectures = "native";
          };
        };
      }

      # Route system traffic via service for specified ports.
      (lib.mkIf cfg.configureFirewall {
        networking.firewall.extraCommands =
          let
            httpParams = lib.optionalString (
              cfg.httpMode == "first"
            ) "-m connbytes --connbytes-dir=original --connbytes-mode=packets --connbytes 1:6";

            udpPorts = lib.concatStringsSep "," cfg.udpPorts;
          in
          ''
            ip46tables -t mangle -I POSTROUTING -p tcp --dport 443 -m connbytes --connbytes-dir=original --connbytes-mode=packets --connbytes 1:6 -m mark ! --mark 0x40000000/0x40000000 -j NFQUEUE --queue-num ${qnum} --queue-bypass
          ''
          + lib.optionalString (cfg.httpSupport) ''
            ip46tables -t mangle -I POSTROUTING -p tcp --dport 80 ${httpParams} -m mark ! --mark 0x40000000/0x40000000 -j NFQUEUE --queue-num ${qnum} --queue-bypass
          ''
          + lib.optionalString (cfg.udpSupport) ''
            ip46tables -t mangle -A POSTROUTING -p udp -m multiport --dports ${udpPorts} -m mark ! --mark 0x40000000/0x40000000 -j NFQUEUE --queue-num ${qnum} --queue-bypass
          '';
      })
    ]
  );

  meta.maintainers = with lib.maintainers; [
    nishimara
  ];
}
