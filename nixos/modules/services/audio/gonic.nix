{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.gonic;
  settingsFormat = pkgs.formats.keyValue {
    mkKeyValue = lib.generators.mkKeyValueDefault { } " ";
    listsAsDuplicateKeys = true;
  };
in
{
  options = {
    services.gonic = {

      enable = lib.mkEnableOption "Gonic music server";

      settings = lib.mkOption rec {
        type = settingsFormat.type;
        apply = lib.recursiveUpdate default;
        default = {
          listen-addr = "127.0.0.1:4747";
          cache-path = "/var/cache/gonic";
          tls-cert = null;
          tls-key = null;
        };
        example = {
          music-path = [ "/mnt/music" ];
          podcast-path = "/mnt/podcasts";
        };
        description = ''
          Configuration for Gonic, see <https://github.com/sentriz/gonic#configuration-options> for supported values.
        '';
      };

    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.gonic = {
      description = "Gonic Media Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart =
          let
            # these values are null by default but should not appear in the final config
            filteredSettings = lib.filterAttrs (
              n: v: !((n == "tls-cert" || n == "tls-key") && v == null)
            ) cfg.settings;
          in
          "${pkgs.gonic}/bin/gonic -config-path ${settingsFormat.generate "gonic" filteredSettings}";
        DynamicUser = true;
        StateDirectory = "gonic";
        CacheDirectory = "gonic";
        WorkingDirectory = "/var/lib/gonic";
        RuntimeDirectory = "gonic";
        RootDirectory = "/run/gonic";
        ReadWritePaths = "";
        BindPaths = [
          cfg.settings.playlists-path
          cfg.settings.podcast-path
        ];
        BindReadOnlyPaths = [
          # gonic can access scrobbling services
          "-/etc/resolv.conf"
          "${config.security.pki.caBundle}:/etc/ssl/certs/ca-certificates.crt"
          builtins.storeDir
        ]
        ++ cfg.settings.music-path
        ++ lib.optional (cfg.settings.tls-cert != null) cfg.settings.tls-cert
        ++ lib.optional (cfg.settings.tls-key != null) cfg.settings.tls-key;
        CapabilityBoundingSet = "";
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        RestrictRealtime = true;
        LockPersonality = true;
        UMask = "0066";
        ProtectHostname = true;
      };
    };
  };

  meta.maintainers = [ lib.maintainers.autrimpo ];
}
