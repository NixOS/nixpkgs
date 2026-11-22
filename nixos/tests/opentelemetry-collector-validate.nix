# Build-time test for the configuration validation of the
# services.opentelemetry-collector module. It needs no VM: everything under
# test happens while the configuration is evaluated and built.
{
  lib,
  runCommand,
  testers,
  writeText,
  evalSystem,
}:
let
  evalService =
    module:
    (evalSystem {
      services.opentelemetry-collector = {
        enable = true;
      }
      // module;
    }).config;

  optionsOf = config: config.services.opentelemetry-collector;
  execStartOf = config: config.systemd.services.opentelemetry-collector.serviceConfig.ExecStart;
  confOf = config: config.system.build.opentelemetryCollectorConfig;

  minimalSettings = {
    receivers.otlp.protocols.http = { };
    exporters.debug = { };
    service.pipelines.logs = {
      receivers = [ "otlp" ];
      exporters = [ "debug" ];
    };
  };

  secretRef = "\${file:/var/lib/secrets/otel-token}";

  # A configuration that reads a secret through a confmap provider. Validation
  # fails on it unless the property is overridden, because the file does not
  # exist in the build sandbox.
  secretSettings = {
    receivers.otlp.protocols.http = { };
    exporters.otlphttp = {
      endpoint = "http://localhost:4318";
      headers.authorization = "Bearer ${secretRef}";
    };
    service.pipelines.logs = {
      receivers = [ "otlp" ];
      exporters = [ "otlphttp" ];
    };
  };

  # A pipeline that references an exporter nobody configured.
  invalidSettings = {
    receivers.otlp.protocols.http = { };
    exporters.debug = { };
    service.pipelines.logs = {
      receivers = [ "otlp" ];
      exporters = [ "nonexistent" ];
    };
  };

  fromSettings = evalService { settings = minimalSettings; };
  fromStoreConfigFile = evalService {
    configFile = writeText "config.yaml" (builtins.toJSON minimalSettings);
  };
  fromExternalConfigFile = evalService {
    configFile = "/etc/opentelemetry-collector/config.yaml";
  };
  withOverrides = evalService {
    settings = secretSettings;
    validateConfigOverrides = [ "exporters::otlphttp::headers::authorization=stub" ];
  };
  withoutOverrides = evalService { settings = secretSettings; };
  invalid = evalService { settings = invalidSettings; };
in
# A configuration built from `settings` is always a store path, so it is always
# validated. This is the regression that motivated the option: the default used
# to be `isStorePath cfg.configFile`, which is false when `configFile` is null.
assert (optionsOf fromSettings).validateConfigFile;
assert (optionsOf fromStoreConfigFile).validateConfigFile;
# A configFile outside the store does not exist at build time, so validation
# must stay off and the service must point at the path verbatim.
assert !(optionsOf fromExternalConfigFile).validateConfigFile;
assert lib.hasSuffix "--config=file:/etc/opentelemetry-collector/config.yaml" (
  execStartOf fromExternalConfigFile
);

runCommand "opentelemetry-collector-validate-test"
  {
    # Building `validated` runs `otelcol validate`, which only passes because
    # the `--set` override replaces the file provider reference.
    validated = confOf withOverrides;
    invalidFailure = testers.testBuildFailure (confOf invalid);
    unresolvableFailure = testers.testBuildFailure (confOf withoutOverrides);
  }
  ''
    # The override applies to validation only: the deployed configuration keeps
    # the provider reference.
    grep -F ${lib.escapeShellArg secretRef} $validated
    ! grep -F stub $validated

    # Validation rejects a config whose pipeline references an undefined
    # component.
    grep -F nonexistent $invalidFailure/testBuildFailure.log

    # Without an override, validation resolves the file provider and fails,
    # because the secret does not exist in the sandbox.
    grep -F /var/lib/secrets/otel-token $unresolvableFailure/testBuildFailure.log

    touch $out
  ''
