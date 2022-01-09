pkgs: driver:
let
  coverage-rc = pkgs.writeText "coverage.rc" ''
    [run]
    include =
        **/site-packages/test_driver/*
  '';

  coverage = "${pkgs.python39Packages.coverage}/bin/coverage";

  pythonButItsCoverage = pkgs.writeScript "python-coverage" ''
    #!${pkgs.runtimeShell}
    set -euxo pipefail
    COVERAGE_RCFILE=${coverage-rc} ${coverage} run -- "$@"
    RETURN_CODE=$?

    if whoami | grep "nixbld"; then
      cp .coverage $out
    fi

    exit $RETURN_CODE
  '';

  coverageDriver = pkgs.runCommand "test-driver-coverage" { } ''
    mkdir -p $out/bin
    cat \
      <(echo "#!${pythonButItsCoverage}") \
      ${driver}/bin/.nixos-test-driver-wrapped \
      > $out/bin/.nixos-test-driver-wrapped
    sed "s@${driver}@$out@" ${driver}/bin/nixos-test-driver > $out/bin/nixos-test-driver
    chmod +x $out/bin/nixos-test-driver
    chmod +x $out/bin/.nixos-test-driver-wrapped
    # exit 1
  '';
in
pkgs.symlinkJoin {
  name = "${driver.name}-coverage";
  paths = [ coverageDriver driver ];
}
