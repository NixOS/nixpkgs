{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.immich-public-proxy;
  format = pkgs.formats.json { };
  inherit (lib)
    types
    mkIf
    mkOption
    mkEnableOption
    ;
in
{
  options.services.immich-public-proxy = {
    enable = mkEnableOption "Immich Public Proxy";
    package = lib.mkPackageOption pkgs "immich-public-proxy" { };

    immichUrl = mkOption {
      type = types.str;
      description = "URL of the Immich instance";
    };

    port = mkOption {
      type = types.port;
      default = 3000;
      description = "The port that IPP will listen on.";
    };
    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open the IPP port in the firewall";
    };

    upload = {
      enable = mkEnableOption ''
        the IPP upload service, which lets visitors of a shared link send photos and videos into it.

        The upload service must be reachable from the browser either under `/upload` on the same
        hostname as IPP, or on a hostname of its own, in which case `settings.ipp.uploadUrl` must be set.
        See <https://docs.ipp.nz/visitor-uploads>
      '';
      port = mkOption {
        type = types.port;
        default = 3001;
        description = "The port that the upload service will listen on.";
      };
      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to open the upload service port in the firewall";
      };
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = format.type;
      };
      default = { };
      description = ''
        Configuration for IPP. See <https://github.com/alangrainger/immich-public-proxy/blob/main/README.md#additional-configuration> for options and defaults.

        The upload service uses the same configuration, and reads only the `ipp.upload` options
        (see <https://docs.ipp.nz/config/upload-service>) and a few shared ones.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.immich-public-proxy = {
      description = "Immich public proxy for sharing albums publicly without exposing your Immich instance";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        IMMICH_URL = cfg.immichUrl;
        IPP_PORT = toString cfg.port;
        IPP_CONFIG = "${format.generate "config.json" cfg.settings}";
      };
      serviceConfig = {
        ExecStart = lib.getExe cfg.package;
        SyslogIdentifier = "ipp";
        User = "ipp";
        Group = "ipp";
        DynamicUser = true;
        Type = "simple";
        Restart = "on-failure";
        RestartSec = 3;

        # Hardening
        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        PrivateUsers = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateMounts = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
      };
    };

    systemd.services.immich-public-proxy-upload = mkIf cfg.upload.enable {
      description = "Immich public proxy upload service for letting visitors add photos to shared links";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = config.systemd.services.immich-public-proxy.environment // {
        IPP_PORT = toString cfg.upload.port;
      };
      # Same hardening as the proxy itself
      serviceConfig = config.systemd.services.immich-public-proxy.serviceConfig // {
        ExecStart = lib.getExe' cfg.package "immich-public-proxy-upload";
        SyslogIdentifier = "ipp-upload";
        User = "ipp-upload";
        Group = "ipp-upload";
      };
    };

    networking.firewall.allowedTCPPorts =
      lib.optional cfg.openFirewall cfg.port ++ lib.optional cfg.upload.openFirewall cfg.upload.port;
  };
  meta.maintainers = with lib.maintainers; [ jaculabilis ];
}
