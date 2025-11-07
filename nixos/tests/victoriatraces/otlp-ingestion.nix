{ lib, pkgs, ... }:
let
  # Simple protobuf trace
  traceGenerator = pkgs.writeScriptBin "trace-generator" ''
    #!${
      pkgs.python3.withPackages (
        ps: with ps; [
          requests
          protobuf
          opentelemetry-proto
          opentelemetry-api
          opentelemetry-sdk
          opentelemetry-exporter-otlp-proto-http
        ]
      )
    }/bin/python3

    import time
    from opentelemetry import trace
    from opentelemetry.sdk.trace import TracerProvider
    from opentelemetry.sdk.trace.export import BatchSpanProcessor
    from opentelemetry.exporter.otlp.proto.http.trace_exporter import OTLPSpanExporter
    from opentelemetry.sdk.resources import Resource

    resource = Resource.create({
        "service.name": "test-service",
        "service.version": "1.0.0"
    })

    provider = TracerProvider(resource=resource)

    otlp_exporter = OTLPSpanExporter(
        endpoint="http://localhost:10428/insert/opentelemetry/v1/traces",
        headers={},
    )

    provider.add_span_processor(BatchSpanProcessor(otlp_exporter))
    trace.set_tracer_provider(provider)

    tracer = trace.get_tracer("test-tracer", "1.0.0")

    # Test span
    with tracer.start_as_current_span("test-span") as span:
        span.set_attribute("http.method", "GET")
        span.set_attribute("http.url", "/test")
        time.sleep(0.1)

    provider.force_flush()

    print("Test trace sent")
  '';
in
{
  name = "victoriatraces-otlp-ingestion";
  meta.maintainers = with lib.maintainers; [ cmacrae ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.victoriatraces = {
        enable = true;
        retentionPeriod = "1d";
      };

      environment.systemPackages = with pkgs; [
        curl
        jq
        traceGenerator
      ];
    };

  testScript = ''
    machine.wait_for_unit("victoriatraces.service")
    machine.wait_for_open_port(10428)
    machine.succeed("curl --fail http://localhost:10428/")
    machine.succeed("trace-generator")

    # Wait for trace to be indexed
    machine.wait_until_succeeds("""
      curl -s 'http://localhost:10428/select/jaeger/api/services' | \
      jq -e '.data[] | select(. == "test-service")'
    """, timeout=10)

    # Query for traces from our test service
    machine.succeed("""
      curl -s 'http://localhost:10428/select/jaeger/api/traces?service=test-service' | \
      jq -e '.data[0].spans[0].operationName' | grep -q 'test-span'
    """)

    # Verify the trace has the expected attributes
    machine.succeed("""
      curl -s 'http://localhost:10428/select/jaeger/api/traces?service=test-service' | \
      jq -e '.data[0].spans[0].tags[] | select(.key == "http.method") | .value == "GET"'
    """)
  '';
}
