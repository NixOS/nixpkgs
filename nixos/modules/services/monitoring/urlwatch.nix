{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.urlwatch;
  format = pkgs.formats.yaml { };
  configurationFile = format.generate "urlwatch.yaml" cfg.configuration;
  urlsFile = lib.pipe cfg.jobs [
    (map (format.generate "jobfile"))
    (map builtins.readFile)
    (builtins.concatStringsSep "---\n")
    (pkgs.writeText "urls.yaml")
  ];
in
{
  options.services.urlwatch = {
    enable = lib.mkEnableOption ''
      url monitoring service
    '';

    package = lib.mkPackageOption pkgs "urlwatch" { };

    configuration = lib.mkOption {
      description = ''
        See https://urlwatch.readthedocs.io/en/latest/configuration.html
      '';
      default = { };
      example = lib.literalExpression ''
        {
          display = {
            new = false;
            error = true;
          };
        }
      '';
      type = format.type;
    };

    jobs = lib.mkOption {
      description = ''
        See https://urlwatch.readthedocs.io/en/latest/jobs.html
      '';
      example = lib.literalExpression ''
        [
          {
            name = nixos;
            url = https://nixos.org;
          }
        ]
      '';
      type = lib.types.listOf format.type;
    };

    startAt = lib.mkOption {
      description = ''
        Specifies how often to poll for changes.
        See {manpage}`systemd.time(7)`
      '';
      default = "*:0/30";
      example = "Sun 14:00:00";
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.urlwatch = {
      description = "urlwatch - monitors webpages for you";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ cfg.package ];
      serviceConfig = {
        Type = "oneshot";
        DynamicUser = lib.mkDefault true;
        StateDirectory = "urlwatch";
        StateDirectoryMode = "0700";
      };
      startAt = cfg.startAt;
      script = ''
        ${lib.getExe cfg.package} --urls ${urlsFile} --config ${configurationFile} --cache $STATE_DIRECTORY/cache
      '';
    };
  };

  meta.maintainers = [ lib.maintainers.flandweber ];
}
