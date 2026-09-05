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
