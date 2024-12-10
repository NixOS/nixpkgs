{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.vmagent;
  settingsFormat = pkgs.formats.json { };
in
{
  imports = [
    (lib.mkRemovedOptionModule [
      "services"
      "vmagent"
      "dataDir"
    ] "dataDir has been deprecated in favor of systemd provided CacheDirectory")
    (lib.mkRemovedOptionModule [
      "services"
      "vmagent"
      "user"
    ] "user has been deprecated in favor of systemd DynamicUser")
    (lib.mkRemovedOptionModule [
      "services"
      "vmagent"
      "group"
    ] "group has been deprecated in favor of systemd DynamicUser")
    (lib.mkRenamedOptionModule
      [ "services" "vmagent" "remoteWriteUrl" ]
      [ "services" "vmagent" "remoteWrite" "url" ]
    )
  ];

  options.services.vmagent = {
    enable = lib.mkEnableOption "vmagent";

    package = lib.mkPackageOption pkgs "vmagent" { };

    remoteWrite = {
      url = lib.mkOption {
        default = null;
        type = lib.types.nullOr lib.types.str;
        description = ''
          Endpoint for prometheus compatible remote_write
        '';
      };
      basicAuthUsername = lib.mkOption {
        default = null;
        type = lib.types.nullOr lib.types.str;
        description = ''
          Basic Auth username used to connect to remote_write endpoint
        '';
      };
      basicAuthPasswordFile = lib.mkOption {
        default = null;
        type = lib.types.nullOr lib.types.str;
        description = ''
          File that contains the Basic Auth password used to connect to remote_write endpoint
        '';
      };
    };

    prometheusConfig = lib.mkOption {
      type = lib.types.submodule { freeformType = settingsFormat.type; };
      description = ''
        Config for prometheus style metrics
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to open the firewall for the default ports.
      '';
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Extra args to pass to `vmagent`. See the docs:
        <https://docs.victoriametrics.com/vmagent.html#advanced-usage>
        or {command}`vmagent -help` for more information.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ 8429 ];

    systemd.services.vmagent =
      let
        prometheusConfig = settingsFormat.generate "prometheusConfig.yaml" cfg.prometheusConfig;
        startCommandLine = lib.concatStringsSep " " (
          [
            "${cfg.package}/bin/vmagent"
            "-promscrape.config=${prometheusConfig}"
          ]
          ++ cfg.extraArgs
          ++ lib.optionals (cfg.remoteWrite.url != null) [
            "-remoteWrite.url=${cfg.remoteWrite.url}"
            "-remoteWrite.tmpDataPath=%C/vmagent/remote_write_tmp"
          ]
          ++ lib.optional (
            cfg.remoteWrite.basicAuthUsername != null
          ) "-remoteWrite.basicAuth.username=${cfg.remoteWrite.basicAuthUsername}"
          ++ lib.optional (
            cfg.remoteWrite.basicAuthPasswordFile != null
          ) "-remoteWrite.basicAuth.passwordFile=\${CREDENTIALS_DIRECTORY}/remote_write_basic_auth_password"
        );
      in
      {
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        description = "vmagent system service";
        serviceConfig = {
          DynamicUser = true;
          User = "vmagent";
          Group = "vmagent";
          Type = "simple";
          Restart = "on-failure";
          CacheDirectory = "vmagent";
          ExecStart = startCommandLine;
          LoadCredential = lib.optional (cfg.remoteWrite.basicAuthPasswordFile != null) [
            "remote_write_basic_auth_password:${cfg.remoteWrite.basicAuthPasswordFile}"
          ];
        };
      };
  };
}
