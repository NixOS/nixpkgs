source $stdenv/setup

postInstall() {

    # Strip some more stuff
    strip -S $out/lib/*/* || true

    # Fix some references to /bin paths in the Thunderbird shell script.
    substituteInPlace $out/bin/thunderbird \
        --replace /bin/pwd "$(type -tP pwd)" \
        --replace /bin/ls "$(type -tP ls)"

    # This fixes starting Thunderbird when there already is a running
    # instance.  The `thunderbird' wrapper script actually expects to
    # be in the same directory as `run-mozilla.sh', apparently.
    libDir=$(cd $out/lib && ls -d thunderbird-*)
    test -n "$libDir"
    cd $out/bin
    mv thunderbird ../lib/$libDir/
    ln -s ../lib/$libDir/thunderbird .

    # Register extensions etc.
    echo "running thunderbird -register..."
    (cd $out/lib/$libDir && LD_LIBRARY_PATH=. ./thunderbird-bin -register) || false

    echo "running regxpcom..."
    (cd $out/lib/$libDir && LD_LIBRARY_PATH=. ./regxpcom) || false

    # Put the Thunderbird icon in the right place.
    ensureDir $out/lib/$libDir/chrome/icons/default
    ln -s ../../../icons/default.xpm  $out/lib/$libDir/chrome/icons/default/
}

genericBuild
