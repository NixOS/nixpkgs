{
  fetchFromGitHub,
  fetchpatch,
  fetchPypi,
  python3,

  # Extra airflow providers to enable
  enabledProviders ? [ ],
}:

let
  python = python3.override {
    self = python;
    packageOverrides = pySelf: pySuper: {
      smmap = pySuper.smmap.overridePythonAttrs rec {
        version = "5.0.2";
        src = fetchFromGitHub {
          owner = "gitpython-developers";
          repo = "smmap";
          tag = "v${version}";
          hash = "sha256-0Y175kjv/8UJpSxtLpWH4/VT7JrcVPAq79Nf3rtHZZM=";
        };
      };
      structlog = pySuper.structlog.overridePythonAttrs (o: rec {
        version = "25.4.0";
        src = fetchFromGitHub {
          owner = "hynek";
          repo = "structlog";
          tag = version;
          hash = "sha256-iNnUogcICQJvHBZO2J8uk4NleQY/ra3ZzxQgnSRKr30=";
        };
        nativeCheckInputs =
          with pySelf;
          o.nativeCheckInputs
          ++ [
            freezegun
            pretend
          ];
      });
      apache-airflow = pySelf.callPackage ./python-package.nix { inherit enabledProviders; };
    };
  };
in
# See note in ./python-package.nix for
# instructions on manually testing the web UI
with python.pkgs;
(toPythonApplication apache-airflow).overrideAttrs (previousAttrs: {
  # Provide access to airflow's modified python package set
  # for the cases where external scripts need to import
  # airflow modules, though *caveat emptor* because many of
  # these packages will not be built by hydra and many will
  # not work at all due to the unexpected version overrides
  # here.
  passthru = (previousAttrs.passthru or { }) // {
    pythonPackages = python.pkgs;
  };
})
