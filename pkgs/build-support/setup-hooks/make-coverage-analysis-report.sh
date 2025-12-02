appendToVar postPhases coverageReportPhase

coverageReportPhase() {
    lcov --directory . --capture --output-file app.info
    set -o noglob
    lcov --remove app.info ${lcovFilter:-"/nix/store/*"} > app2.info
    set +o noglob
    mv app2.info app.info

    mkdir -p $out/coverage
    genhtml app.info $lcovExtraTraceFiles -o $out/coverage > log

    # Grab the overall coverage percentage so that Hydra can plot it over time.
    mkdir -p $out/nix-support
    lineCoverage="$(sed 's/.*lines\.*: \([0-9\.]\+\)%.*/\1/; t ; d' log)"
    functionCoverage="$(sed 's/.*functions\.*: \([0-9\.]\+\)%.*/\1/; t ; d' log)"
    if [ -z "$lineCoverage" -o -z "$functionCoverage" ]; then
        echo "failed to get coverage statistics"
        exit 1
    fi
    echo "lineCoverage $lineCoverage %" >> $out/nix-support/hydra-metrics
    echo "functionCoverage $functionCoverage %" >> $out/nix-support/hydra-metrics

    echo "report coverage $out/coverage" >> $out/nix-support/hydra-build-products
}
