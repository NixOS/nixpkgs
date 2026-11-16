{
  config,
  lib,
  options,
  pkgs,
  utils,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.services.opensearch-dashboards;
  yaml = pkgs.formats.yaml { };
  stateDir = "/var/lib/opensearch-dashboards";
in
{
  meta.maintainers = with lib.maintainers; [
    makefu
    shymega
  ];

  options.services.opensearch-dashboards = {
    enable = lib.mkEnableOption "OpenSearch Dashboards";

    package = lib.mkPackageOption pkgs "OpenSearch Dashboards" {
      default = [ "opensearch-dashboards" ];
    };

    user = mkOption {
      type = types.str;
      default = "opensearch-dashboards";
      description = ''
        The user to run OpenSearch Dashboards under.
      '';
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = yaml.type;
      };
      default = { };
      example = lib.literalExpression ''
        {
          opensearch = {
            username = "foo";
            password._secret = "/run/keys/opensearch_password";
          };

          server = {
            name = "your-hostname";
            port = 5601;
            maxPayloadbytes = 104857;
          };
        };
      '';
      description = ''
        OpenSearch Dashboards settings.

        Available settings can be found by looking at the
        [opensearch_dashboards.yml](https://github.com/opensearch-project/OpenSearch-Dashboards/blob/main/config/opensearch_dashboards.yml)
        from the Opensearch Dashboards repo.

        {file}`config/nixos_site_settings.json` file,
        attribute set containing the attribute
        `_secret` - a string pointing to a file
        containing the value the option should be set to. See the
        example to get a better picture of this: in the resulting
        {file}`opensearch_dashboards.yml` file,
        the `opensearch.password` key will
        be set to the contents of the
        {file}`/run/keys/opensearch_password`
        file.
      '';
    };
  };

  config = mkIf (cfg.enable) {
    systemd.services.opensearch-dashboards = {
      description = "OpenSearch Dashboards Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment = {
        BABEL_CACHE_PATH = "${stateDir}/.babelcache.json";
      };
      serviceConfig =
        let
          configPath = stateDir + "/opensearch_dashboards.yml";
        in
        {
          ExecStartPre = pkgs.writeShellScript "dashboards-exec-pre" ''
            set -euo pipefail
            umask 077
            ${utils.genJqSecretsReplacementSnippet cfg.settings configPath}
            chown ${cfg.user} ${configPath}
          '';
          ExecStart = "${cfg.package}/bin/opensearch-dashboards --config ${configPath} --path.data ${stateDir}";
          StateDirectory = "opensearch-dashboards";
          User = cfg.user;
          DynamicUser = true;
        };
    };
  };
}
