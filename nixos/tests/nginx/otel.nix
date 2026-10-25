{
  mkPackage ? builtins.getAttr "nginx",
  name ? "default",
  ...
}:
{
  name = "nginx-otel-${name}";

  nodes.machine =
    { pkgs, ... }:
    {
      services.opentelemetry-collector = {
        enable = true;
        settings = {
          receivers.otlp.protocols.grpc.endpoint = "127.0.0.1:4317";
          exporters.debug.verbosity = "detailed";
          service.pipelines.traces = {
            receivers = [ "otlp" ];
            exporters = [ "debug" ];
          };
        };
      };
      services.nginx = {
        enable = true;
        package = mkPackage pkgs;
        dynamicModules = ms: [ ms.otel ];
        commonHttpConfig = ''
          otel_exporter {
            endpoint localhost:4317;
          }
          otel_service_name "nginx-test";
          otel_trace on;
        '';
        virtualHosts."localhost".locations."/".extraConfig = ''
          otel_trace_context propagate;
          otel_span_name "handle";
          return 200 "otel-ok";
        '';
      };
    };

  testScript =
    { nodes, ... }:
    let
      cfg = nodes.machine.services.nginx;
    in
    ''
      machine.wait_for_unit("opentelemetry-collector")
      machine.wait_for_open_port(4317)
      machine.wait_for_unit("nginx")
      machine.wait_for_open_port(80)

      response = machine.wait_until_succeeds("curl -fsS http://127.0.0.1/")
      t.assertIn("otel-ok", response)

      machine.wait_until_succeeds("journalctl -u opentelemetry-collector --grep 'service.name: Str\\(nginx-test\\)'")
      machine.wait_until_succeeds("journalctl -u opentelemetry-collector --grep 'Name +: handle'")
    '';
}
