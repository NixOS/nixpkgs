postPhases+=" coverageReportPhase"

coverageReportPhase() {
    lcov --directory . --capture --output-file app.info
    set -o noglob
    lcov --remove app.info ${lcovFilter:-"/nix/store/*"} > app2.info
    set +o noglob
    mv app2.info app.info

    mkdir -p $out/coverage
    genhtml app.info $lcovExtraTraceFiles -o $out/coverage > log

    # Grab the overall coverage percentage for use in release overviews.
    mkdir -p $out/nix-support
    grep "Overall coverage rate" log | sed 's/^.*(\(.*\)%).*$/\1/' > $out/nix-support/coverage-rate

    echo "report coverage $out/coverage" >> $out/nix-support/hydra-build-products
}
