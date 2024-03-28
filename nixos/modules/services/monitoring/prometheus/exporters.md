# Prometheus exporters {#module-services-prometheus-exporters}

Prometheus exporters provide metrics for the
[prometheus monitoring system](https://prometheus.io).

## Configuration {#module-services-prometheus-exporters-configuration}

One of the most common exporters is the
[node exporter](https://github.com/prometheus/node_exporter),
it provides hardware and OS metrics from the host it's
running on. The exporter could be configured as follows:
```nix
{
  services.prometheus.exporters.node = {
    enable = true;
    port = 9100;
    enabledCollectors = [
      "logind"
      "systemd"
    ];
    disabledCollectors = [
      "textfile"
    ];
    openFirewall = true;
    firewallFilter = "-i br0 -p tcp -m tcp --dport 9100";
  };
}
```
It should now serve all metrics from the collectors that are explicitly
enabled and the ones that are
[enabled by default](https://github.com/prometheus/node_exporter#enabled-by-default),
via http under `/metrics`. In this
example the firewall should just allow incoming connections to the
exporter's port on the bridge interface `br0` (this would
have to be configured separately of course). For more information about
configuration see `man configuration.nix` or search through
the [available options](https://nixos.org/nixos/options.html#prometheus.exporters).

Prometheus can now be configured to consume the metrics produced by the exporter:
```nix
{
    services.prometheus = {
      # ...

      scrapeConfigs = [
        {
          job_name = "node";
          static_configs = [{
            targets = [ "localhost:${toString config.services.prometheus.exporters.node.port}" ];
          }];
        }
      ];

      # ...
    };
}
```

## Adding a new exporter {#module-services-prometheus-exporters-new-exporter}

To add a new exporter, it has to be packaged first (see
`nixpkgs/pkgs/servers/monitoring/prometheus/` for
examples), then a module can be added. The postfix exporter is used in this
example:

  - Some default options for all exporters are provided by
    `nixpkgs/nixos/modules/services/monitoring/prometheus/exporters.nix`:

      - `enable`
      - `port`
      - `listenAddress`
      - `extraFlags`
      - `openFirewall`
      - `firewallFilter`
      - `user`
      - `group`
  - As there is already a package available, the module can now be added. This
    is accomplished by adding a new file to the
    `nixos/modules/services/monitoring/prometheus/exporters/`
    directory, which will be called postfix.nix and contains all exporter
    specific options and configuration:
    ```nix
    # nixpkgs/nixos/modules/services/prometheus/exporters/postfix.nix
    { config, lib, pkgs, options }:

    with lib;

    let
      # for convenience we define cfg here
      cfg = config.services.prometheus.exporters.postfix;
    in
    {
      port = 9154; # The postfix exporter listens on this port by default

      # `extraOpts` is an attribute set which contains additional options
      # (and optional overrides for default options).
      # Note that this attribute is optional.
      extraOpts = {
        telemetryPath = mkOption {
          type = types.str;
          default = "/metrics";
          description = ''
            Path under which to expose metrics.
          '';
        };
        logfilePath = mkOption {
          type = types.path;
          default = /var/log/postfix_exporter_input.log;
          example = /var/log/mail.log;
          description = ''
            Path where Postfix writes log entries.
            This file will be truncated by this exporter!
          '';
        };
        showqPath = mkOption {
          type = types.path;
          default = /var/spool/postfix/public/showq;
          example = /var/lib/postfix/queue/public/showq;
          description = ''
            Path at which Postfix places its showq socket.
          '';
        };
      };

      # `serviceOpts` is an attribute set which contains configuration
      # for the exporter's systemd service. One of
      # `serviceOpts.script` and `serviceOpts.serviceConfig.ExecStart`
      # has to be specified here. This will be merged with the default
      # service configuration.
      # Note that by default 'DynamicUser' is 'true'.
      serviceOpts = {
        serviceConfig = {
          DynamicUser = false;
          ExecStart = ''
            ${pkgs.prometheus-postfix-exporter}/bin/postfix_exporter \
              --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
              --web.telemetry-path ${cfg.telemetryPath} \
              ${concatStringsSep " \\\n  " cfg.extraFlags}
          '';
        };
      };
    }
    ```
  - This should already be enough for the postfix exporter. Additionally one
    could now add assertions and conditional default values. This can be done
    in the 'meta-module' that combines all exporter definitions and generates
    the submodules:
    `nixpkgs/nixos/modules/services/prometheus/exporters.nix`

## Updating an exporter module {#module-services-prometheus-exporters-update-exporter-module}

Should an exporter option change at some point, it is possible to add
information about the change to the exporter definition similar to
`nixpkgs/nixos/modules/rename.nix`:
```nix
{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus.exporters.nginx;
in
{
  port = 9113;
  extraOpts = {
    # additional module options
    # ...
  };
  serviceOpts = {
    # service configuration
    # ...
  };
  imports = [
    # 'services.prometheus.exporters.nginx.telemetryEndpoint' -> 'services.prometheus.exporters.nginx.telemetryPath'
    (mkRenamedOptionModule [ "telemetryEndpoint" ] [ "telemetryPath" ])

    # removed option 'services.prometheus.exporters.nginx.insecure'
    (mkRemovedOptionModule [ "insecure" ] ''
      This option was replaced by 'prometheus.exporters.nginx.sslVerify' which defaults to true.
    '')
    ({ options.warnings = options.warnings; })
  ];
}
```
