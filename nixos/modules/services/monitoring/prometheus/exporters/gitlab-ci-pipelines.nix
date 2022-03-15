{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus.exporters.gitlab-ci-pipelines;
in
{
  port = 9080;
  extraOpts = {
    configuration = mkOption {
      type = types.attrs;
      default =
        { };
      description = ''
        gitlab-ci-pipelines configuration as a nix attrset.

        See the official documentation for the supported options:
        https://github.com/mvisonneau/gitlab-ci-pipelines-exporter/blob/main/docs/configuration_syntax.md
      '';
      example = {
        gitlab.url = "https://gitlab.com";
        projects = [{ name = "foo/project"; }];
      };
    };

    environmentFile = mkOption
      {
        type = types.nullOr types.path;
        default = null;
        example = "/run/secrets/gitlab-ci-pipelines.env";
        description = ''
          Path to a file that defines secrets for the gitlab-ci-pipelines exporter.
          This file should conform to systemd EnvironmentFile syntax. See systemd.exec(5) man page.
        '';
      };

  };

  serviceOpts =
    let
      addressConfig = {
        server.listen_address = "${cfg.listenAddress}:${toString cfg.port}";
      };
      combinedConfig = recursiveUpdate addressConfig cfg.configuration;
      configFile = "${pkgs.writeText "gitlab-ci-pipelines-conf.yml" (builtins.toJSON combinedConfig) }";
    in
    {
      serviceConfig = {
        DynamicUser = true;
        EnvironmentFile = optional (cfg.environmentFile != null) cfg.environmentFile;
        ExecStart = ''
          ${pkgs.prometheus-gitlab-ci-pipelines-exporter}/bin/gitlab-ci-pipelines-exporter run \
          --config ${escapeShellArg configFile}
        '';
      };
    };
}
