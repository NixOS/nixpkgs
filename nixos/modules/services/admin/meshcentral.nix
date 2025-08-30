{
  config,
  pkgs,
  lib,
  utils,
  ...
}:
let
  cfg = config.services.meshcentral;
  configFormat = pkgs.formats.json { };
in
with lib;
{
  options.services.meshcentral = with types; {
    enable = mkEnableOption "MeshCentral computer management server";
    package = mkPackageOption pkgs "meshcentral" { };
    settings = mkOption {
      description = ''
        Settings for MeshCentral. Refer to upstream documentation for details:

        - [JSON Schema definition](https://github.com/Ylianst/MeshCentral/blob/master/meshcentral-config-schema.json)
        - [simple sample configuration](https://github.com/Ylianst/MeshCentral/blob/master/sample-config.json)
        - [complex sample configuration](https://github.com/Ylianst/MeshCentral/blob/master/sample-config-advanced.json)
        - [Old homepage with documentation link](https://www.meshcommander.com/meshcentral2)

        Options containing secret data should be set to an attribute set
        containing the attribute `_secret` - a string pointing to a file
        containing the value the option should be set to.
      '';
      type = types.submodule {
        freeformType = configFormat.type;
      };
      example = {
        settings = {
          WANonly = true;
          Cert = "meshcentral.example.com";
          TlsOffload = "10.0.0.2,fd42::2";
          Port = 4430;
        };
        domains."".certUrl = "https://meshcentral.example.com/";
      };
    };
  };
  config = mkIf cfg.enable {
    services.meshcentral.settings.settings.autoBackup.backupPath =
      lib.mkDefault "/var/lib/meshcentral/backups";
    systemd.services.meshcentral = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        # Run ExecStartPre as root to ensure access to secret files given dynamic user is turned on
        ExecStartPre = "+${pkgs.writeShellScript "meshcentral-pre-start" (utils.genJqSecretsReplacementSnippet cfg.settings "/run/meshcentral/config.json")}";
        ExecStart = "${cfg.package}/bin/meshcentral --datapath /var/lib/meshcentral --configfile /run/meshcentral/config.json";
        DynamicUser = true;
        StateDirectory = "meshcentral";
        StateDirectoryMode = "0700";
        CacheDirectory = "meshcentral";
        CacheDirectoryMode = "0700";
        RuntimeDirectory = "meshcentral";
        RuntimeDirectoryMode = "0700";
      };
    };
  };
  meta.maintainers = [ ];
}
