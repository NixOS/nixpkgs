{
  config,
  lib,
  ...
}:

let
  cfg = config.services.prometheus.exporters.mastodon;
  package = config.services.mastodon.package;
  inherit (lib)
    mkOption
    types
    mkMerge
    mkIf
    ;
in
{
  port = 9394;

  extraOpts = {
    prefix = mkOption {
      type = types.str;
      default = "mastodon_";
      description = ''
        The prefix for Mastodon metrics
      '';
    };

    user = mkOption {
      type = types.str;
      default = config.services.mastodon.user;
      defaultText = "config.services.mastodon.user";
      description = ''
        Mastodon user
      '';
    };

    group = mkOption {
      type = types.str;
      default = config.services.mastodon.group;
      defaultText = "config.services.mastodon.group";
      description = ''
        Mastodon group
      '';
    };
  };

  serviceOpts = mkMerge [
    {
      serviceConfig = {
        ExecStart = ''
          ${package}/bin/prometheus_exporter \
            -p '${toString cfg.port}' \
            -b '${cfg.listenAddress}' \
            --prefix '${cfg.prefix}'
        '';
      };
    }

    (mkIf config.services.mastodon.enable {
      after = [ "mastodon.target" ];
      requires = [ "mastodon.target" ];
    })
  ];
}
