{ runCommand, lcov, rsync, coverageRuns, lcovFilter ? [ "/nix/store/*" ], baseDirHack ? false }:

runCommand "coverage"
  { buildInputs = [ lcov rsync ];
    inherit lcovFilter baseDirHack;
  }
  ''
    mkdir -p $TMPDIR/gcov $out/nix-support $out/coverage
    info=$out/coverage/full.info

    for p in ${toString coverageRuns}; do
        if [ -f $p/nix-support/hydra-build-products ]; then
            cat $p/nix-support/hydra-build-products >> $out/nix-support/hydra-build-products
        fi

        [ ! -e $p/nix-support/failed ] || touch $out/nix-support/failed

        opts=
        for d in $p/coverage-data/*; do
            for i in $(cd $d/nix/store && ls); do
                if ! [ -e /nix/store/$i/.build ]; then continue; fi
                if [ -e $TMPDIR/gcov/nix/store/$i ]; then continue; fi
                echo "copying $i..."
                rsync -a /nix/store/$i/.build/* $TMPDIR/gcov/
                if [ -n "$baseDirHack" ]; then
                    opts="-b $TMPDIR/gcov/$(cd /nix/store/$i/.build && ls)"
                fi
            done

            for i in $(cd $d/nix/store && ls); do
                rsync -a $d/nix/store/$i/.build/* $TMPDIR/gcov/ --include '*/' --include '*.gcda' --exclude '*'
            done
        done

        chmod -R u+w $TMPDIR/gcov

        echo "producing info..."
        geninfo --ignore-errors source,gcov $TMPDIR/gcov --output-file $TMPDIR/app.info $opts
        cat $TMPDIR/app.info >> $info
    done

    echo "making report..."
    set -o noglob
    lcov --remove $info ''$lcovFilter > $info.tmp
    set +o noglob
    mv $info.tmp $info
    genhtml --show-details $info -o $out/coverage
    echo "report coverage $out/coverage" >> $out/nix-support/hydra-build-products
  ''
