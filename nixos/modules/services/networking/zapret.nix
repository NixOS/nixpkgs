{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.zapret;

  whitelist = lib.optionalString (
    cfg.whitelist != null
  ) "--hostlist ${pkgs.writeText "zapret-whitelist" (lib.concatStringsSep "\n" cfg.whitelist)}";

  blacklist =
    lib.optionalString (cfg.blacklist != null)
      "--hostlist-exclude ${pkgs.writeText "zapret-blacklist" (lib.concatStringsSep "\n" cfg.blacklist)}";

  ports = if cfg.httpSupport then "80,443" else "443";
in
{
  options.services.zapret = {
    enable = lib.mkEnableOption "the Zapret DPI bypass service.";
    package = lib.mkPackageOption pkgs "zapret" { };
    params = lib.mkOption {
      default = [ ];
      type = with lib.types; listOf str;
      example = ''
        [
          "--dpi-desync=fake,disorder2"
          "--dpi-desync-ttl=1"
          "--dpi-desync-autottl=2"
        ];
      '';
      description = ''
        Specify the bypass parameters for Zapret binary.
        There are no universal parameters as they vary between different networks, so you'll have to find them yourself.

        This can be done by running the `blockcheck` binary from zapret package, i.e. `nix-shell -p zapret --command blockcheck`.
        It'll try different params and then tell you which params are working for your network.
      '';
    };
    whitelist = lib.mkOption {
      default = null;
      type = with lib.types; nullOr (listOf str);
      example = ''
        [
          "youtube.com"
          "googlevideo.com"
          "ytimg.com"
          "youtu.be"
        ]
      '';
      description = ''
        Specify a list of domains to bypass. All other domains will be ignored.
        You can specify either whitelist or blacklist, but not both.
        If neither are specified, then bypass all domains.

        It is recommended to specify the whitelist. This will make sure that other resources won't be affected by this service.
      '';
    };
    blacklist = lib.mkOption {
      default = null;
      type = with lib.types; nullOr (listOf str);
      example = ''
        [
          "example.com"
        ]
      '';
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
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        assertions = [
          {
            assertion = (cfg.whitelist == null) || (cfg.blacklist == null);
            message = "Can't specify both whitelist and blacklist.";
          }
          {
            assertion = (builtins.length cfg.params) != 0;
            message = "You have to specify zapret parameters. See the params option's description.";
          }
        ];

        systemd.services.zapret = {
          description = "DPI bypass service";
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];
          serviceConfig = {
            ExecStart = "${cfg.package}/bin/nfqws --pidfile=/run/nfqws.pid ${lib.concatStringsSep " " cfg.params} ${whitelist} ${blacklist} --qnum=${toString cfg.qnum}";
            Type = "simple";
            PIDFile = "/run/nfqws.pid";
            Restart = "always";
            RuntimeMaxSec = "1h"; # This service loves to crash silently or cause network slowdowns. It also restarts instantly. In my experience restarting it hourly provided the best experience.

            # hardening
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
        networking.firewall.extraCommands = ''
          iptables -t mangle -I POSTROUTING -p tcp -m multiport --dports ${ports} -m connbytes --connbytes-dir=original --connbytes-mode=packets --connbytes 1:6 -m mark ! --mark 0x40000000/0x40000000 -j NFQUEUE --queue-num ${toString cfg.qnum} --queue-bypass
        '';
      })
    ]
  );

  meta.maintainers = with lib.maintainers; [
    voronind
    nishimara
  ];
}
