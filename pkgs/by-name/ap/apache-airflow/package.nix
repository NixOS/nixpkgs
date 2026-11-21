{
  python3,
  runCommand,

  # Extra airflow providers to enable
  enabledProviders ? [ ],
}:

let
  apache-airflow = python3.pkgs.callPackage ./python-package.nix {
    inherit enabledProviders;
  };
in
# See note in ./python-package.nix for
# instructions on manually testing the web UI
(python3.pkgs.toPythonApplication apache-airflow).overrideAttrs (previousAttrs: {
  # Provide access to airflow's modified python package set
  # for the cases where external scripts need to import
  # airflow modules, though *caveat emptor* because many of
  # these packages will not be built by hydra and many will
  # not work at all due to the unexpected version overrides
  # here.
  passthru = (previousAttrs.passthru or { }) // {
    pythonPackages = python3.pkgs // {
      inherit apache-airflow;
    };
    tests = (previousAttrs.passthru.tests or { }) // {
      python-with-packages =
        let
          pythonEnv = python3.withPackages (_: [ apache-airflow ]);
        in
        runCommand "apache-airflow-python-with-packages-test" { } ''
          HOME=$(mktemp -d) ${pythonEnv}/bin/python -c '
          from airflow.sdk.configuration import conf
          conf.load_test_config()
          from airflow.config_templates.airflow_local_settings import DEFAULT_LOGGING_CONFIG
          assert DEFAULT_LOGGING_CONFIG
          '
          HOME=$(mktemp -d) ${pythonEnv}/bin/airflow version
          touch $out
        '';
    };
  };
})
