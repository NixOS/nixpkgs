#!/usr/bin/env bash

source $stdenv/setup

checkPhase() {
    echo "Testing bbtools - wrappers"
    echo "> Testing bbmap"
    $out/bin/bbmap.sh --version 2>&1
    $out/bin/bbmap.sh --version 2>&1 | grep "BBMap"
    echo "> Testing bbmerge"
    $out/bin/bbmerge.sh --version 2>&1
    $out/bin/bbmerge.sh --version 2>&1 | grep "BBMerge"
    echo "> Testing bbduk"
    $out/bin/bbduk.sh --version 2>&1
    $out/bin/bbduk.sh --version 2>&1 | grep "BBDuk"
    echo "> Testing bbmask"
    $out/bin/bbmask.sh --version 2>&1
    $out/bin/bbmask.sh --version 2>&1 | grep "BBMask"
    echo "> Testing bbnorm"
    $out/bin/bbnorm.sh --version 2>&1
    $out/bin/bbnorm.sh --version 2>&1 | grep "Norm"

    echo "Testing java usability"
    $out/bin/bbmerge.sh in=$out/bin/resources/sample1.fq.gz out=/dev/null

    echo "Testing python usability"
    echo "... skipped"
    # FIXME Disabled as this code depends on mpld3 which is not yet available in nixpkgs
    #$out/bin/readqc.sh in=$out/bin/resources/sample1.fq.gz  out=/dev/null

}

installPhase() {
    mkdir -p $out/bin
    cp -r * $out/bin
}

fixupPhase() {
    patchShebangs *.sh

    # Check phase is skipped due to lack of a makefile but we still want to run the tests anyway
    checkPhase
}

genericBuild
