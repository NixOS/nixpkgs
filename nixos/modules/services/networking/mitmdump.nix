{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mapAttrs'
    mkOption
    nameValuePair
    types
    ;
  inherit (types)
    attrsOf
    listOf
    path
    port
    submodule
    str
    ;

  cfg = config.services.mitmdump;

  mitmdumpScript = pkgs.writers.writePython3Bin "mitmdump" {
    libraries =
      let
        p = pkgs.python3Packages;
      in
      [
        p.systemd
        p.mitmproxy
      ];
    flakeIgnore = [ "E501" ];
  } ./mitmdump/wrapper.py;
in
{
  options.services.mitmdump = {
    addons = mkOption {
      type = attrsOf path;
      default = [ ];
      description = ''
        Addons available to the be added to the mitmdump instance.

        To enabled one, add it to the `enabledAddons` option.
      '';
    };

    instances = mkOption {
      default = { };
      description = "Mitmdump instance.";
      type = attrsOf (
        submodule (
          { name, ... }:
          {
            options = {
              package = lib.mkPackageOption pkgs "mitmproxy" { };

              serviceName = mkOption {
                type = str;
                description = ''
                  Name of the mitmdump system service.
                '';
                default = "mitmdump-${name}.service";
                readOnly = true;
              };

              listenHost = mkOption {
                type = str;
                default = "127.0.0.1";
                description = ''
                  Host the mitmdump instance will connect on.
                '';
              };

              listenPort = mkOption {
                type = port;
                description = ''
                  Port the mitmdump instance will listen on.

                  The upstream port from the client's perspective.
                '';
              };

              upstreamHost = mkOption {
                type = str;
                default = "http://127.0.0.1";
                description = ''
                  Host the mitmdump instance will connect to.

                  If only an IP or domain is provided,
                  mitmdump will default to connect using HTTPS.
                  If this is not wanted, prefix the IP or domain with the 'http://' protocol.
                '';
              };

              upstreamPort = mkOption {
                type = port;
                description = ''
                  Port the mitmdump instance will connect to.

                  The port the server is listening on.
                '';
              };

              after = mkOption {
                type = listOf str;
                default = [ ];
                description = ''
                  Systemd services that must be started before this mitmdump proxy instance.

                  You are guaranteed the mitmdump is listening on the `listenPort`
                  when its systemd service has started.
                '';
              };

              enabledAddons = mkOption {
                type = listOf path;
                default = [ ];
                description = ''
                  Addons to enable on this mitmdump instance.
                '';
                example = lib.literalExpression ''[ config.services.mitmdump.addons.logger ]'';
              };

              extraArgs = mkOption {
                type = listOf str;
                default = [ ];
                description = ''
                  Extra arguments to pass to the mitmdump instance.

                  See upstream [manual](https://docs.mitmproxy.org/stable/concepts/options/#flow_detail) for all possible options.
                '';
                example = lib.literalExpression ''[ "--set" "verbose_pattern=/api" ]'';
              };
            };
          }
        )
      );
    };
  };

  config = {
    systemd.services = mapAttrs' (
      name: cfg':
      nameValuePair "mitmdump-${name}" {
        environment = {
          "HOME" = "/var/lib/private/mitmdump-${name}";
          "MITMDUMP_BIN" = "${cfg'.package}/bin/mitmdump";
        };
        serviceConfig = {
          Type = "notify";
          Restart = "on-failure";
          StandardOutput = "journal";
          StandardError = "journal";

          DynamicUser = true;
          WorkingDirectory = "/var/lib/mitmdump-${name}";
          StateDirectory = "mitmdump-${name}";

          ExecStart =
            let
              addons = lib.concatMapStringsSep " " (addon: "-s ${addon}") cfg'.enabledAddons;
              extraArgs = lib.concatStringsSep " " cfg'.extraArgs;
            in
            "${lib.getExe mitmdumpScript} --listen_host ${cfg'.listenHost} --listen_port ${toString cfg'.listenPort} --upstream_host ${cfg'.upstreamHost} --upstream_port ${toString cfg'.upstreamPort} ${addons} ${extraArgs}";
        };
        requires = cfg'.after;
        after = cfg'.after;
        wantedBy = [ "multi-user.target" ];
      }
    ) cfg.instances;
  };

  meta.maintainers = lib.maintainers.ibizaman;
}
