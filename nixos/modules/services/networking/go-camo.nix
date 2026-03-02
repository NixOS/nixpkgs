{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.services.go-camo;
  inherit (lib)
    mkOption
    mkEnableOption
    mkIf
    mkMerge
    types
    optionalString
    ;
in
{
  options.services.go-camo = {
    enable = mkEnableOption "go-camo service";
    listen = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Address:Port to bind to for HTTP (default: 0.0.0.0:8080).";
      apply = v: optionalString (v != null) "--listen=${v}";
    };
    sslListen = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Address:Port to bind to for HTTPS.";
      apply = v: optionalString (v != null) "--ssl-listen=${v}";
    };
    sslKey = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Path to TLS private key.";
      apply = v: optionalString (v != null) "--ssl-key=${v}";
    };
    sslCert = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Path to TLS certificate.";
      apply = v: optionalString (v != null) "--ssl-cert=${v}";
    };
    keyFile = mkOption {
      type = types.path;
      default = null;
      description = ''
        A file containing the HMAC key to use for signing URLs.
        The file can contain any string. Can be generated using "openssl rand -base64 18 > the_file".
      '';
    };
    extraOptions = mkOption {
      type = with types; listOf str;
      default = [ ];
      description = "Extra options passed to the go-camo command.";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.go-camo = {
      description = "go-camo service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment = {
        GOCAMO_HMAC_FILE = "%d/hmac";
      };
      script = ''
        GOCAMO_HMAC="$(cat "$GOCAMO_HMAC_FILE")"
        export GOCAMO_HMAC
        exec ${
          lib.escapeShellArgs (
            lib.lists.remove "" (
              [
                "${pkgs.go-camo}/bin/go-camo"
                cfg.listen
                cfg.sslListen
                cfg.sslKey
                cfg.sslCert
              ]
              ++ cfg.extraOptions
            )
          )
        }
      '';
      serviceConfig = {
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        DynamicUser = true;
        User = "gocamo";
        Group = "gocamo";
        LoadCredential = [
          "hmac:${cfg.keyFile}"
        ];
      };
    };
  };
}
