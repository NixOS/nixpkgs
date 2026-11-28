# OpenTelemetry (OTLP) options shared by the Hydra services built with the
# `otel` cargo feature.
# Synced with https://github.com/NixOS/hydra/blob/master/nixos-modules/otel.nix
{ lib }:

{
  # `component` names the service in option descriptions; `binary` is what the
  # collector sees when `serviceName` is left unset.
  mkOtelOption =
    { component, binary }:
    lib.mkOption {
      description = "OpenTelemetry (OTLP) tracing options for ${component}.";
      default = { };
      type = lib.types.submodule {
        options = {
          enable = lib.mkEnableOption ''
            OpenTelemetry tracing. This builds ${component} with the `otel`
            cargo feature and exports spans via OTLP/gRPC, configured through
            the standard `OTEL_*` environment variables
          '';

          endpoint = lib.mkOption {
            type = lib.types.nullOr lib.types.singleLineStr;
            default = null;
            example = "http://127.0.0.1:4317";
            description = ''
              OTLP collector endpoint (`OTEL_EXPORTER_OTLP_ENDPOINT`). The
              exporter uses gRPC, so point it at the gRPC port (typically 4317).
            '';
          };

          protocol = lib.mkOption {
            type = lib.types.nullOr (
              lib.types.enum [
                "grpc"
                "http/protobuf"
                "http/json"
              ]
            );
            default = null;
            description = "OTLP protocol (`OTEL_EXPORTER_OTLP_PROTOCOL`).";
          };

          headers = lib.mkOption {
            type = lib.types.nullOr lib.types.singleLineStr;
            default = null;
            example = "authorization=Bearer token";
            description = ''
              Headers sent to the collector (`OTEL_EXPORTER_OTLP_HEADERS`). They
              end up in the world-readable systemd unit, so do not put secrets
              here.
            '';
          };

          serviceName = lib.mkOption {
            type = lib.types.nullOr lib.types.singleLineStr;
            default = null;
            description = ''
              Service name reported to the collector (`OTEL_SERVICE_NAME`).
              Defaults to the binary name (`${binary}`).
            '';
          };

          extraEnv = lib.mkOption {
            type = lib.types.attrsOf lib.types.singleLineStr;
            default = { };
            example = {
              OTEL_TRACES_SAMPLER = "parentbased_traceidratio";
              OTEL_TRACES_SAMPLER_ARG = "0.1";
            };
            description = "Additional `OTEL_*` environment variables not exposed as dedicated options.";
          };
        };
      };
    };

  # Package option whose default is built with the `otel` feature when tracing
  # is enabled.
  mkPackageOption =
    {
      pkgs,
      name,
      otelCfg,
      otelPath,
    }:
    lib.mkOption {
      type = lib.types.package;
      default = pkgs.${name}.override { withOtel = otelCfg.enable; };
      defaultText = lib.literalExpression "pkgs.${name}.override { withOtel = config.${otelPath}.enable; }";
      description = "The `${name}` package to use.";
    };

  # The `OTEL_*` environment of a service. Empty when tracing is off, so it can
  # be merged unconditionally.
  otelEnv =
    otel:
    lib.optionalAttrs otel.enable (
      lib.filterAttrs (_: v: v != null) {
        OTEL_EXPORTER_OTLP_ENDPOINT = otel.endpoint;
        OTEL_EXPORTER_OTLP_PROTOCOL = otel.protocol;
        OTEL_EXPORTER_OTLP_HEADERS = otel.headers;
        OTEL_SERVICE_NAME = otel.serviceName;
      }
      // otel.extraEnv
    );
}
