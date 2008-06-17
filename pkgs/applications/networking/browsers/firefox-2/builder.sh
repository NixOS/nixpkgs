source $stdenv/setup

postInstall=postInstall
postInstall() {

    # Strip some more stuff
    strip -S $out/lib/*/* || true

    # Fix some references to /bin paths in the Firefox shell script.
    substituteInPlace $out/bin/firefox \
        --replace /bin/pwd "$(type -tP pwd)" \
        --replace /bin/ls "$(type -tP ls)"
    
    # This fixes starting Firefox when there already is a running
    # instance.  The `firefox' wrapper script actually expects to be
    # in the same directory as `run-mozilla.sh', apparently.
    libDir=$(cd $out/lib && ls -d firefox-*)
    test -n "$libDir"
    cd $out/bin
    mv firefox ../lib/$libDir/
    ln -s ../lib/$libDir/firefox .

    # Register extensions etc.
    echo "running firefox -register..."
    (cd $out/lib/$libDir && LD_LIBRARY_PATH=. ./firefox-bin -register) || false

    echo "running regxpcom..."
    (cd $out/lib/$libDir && LD_LIBRARY_PATH=. ./regxpcom) || false

    # Put the Firefox icon in the right place.
    ensureDir $out/lib/$libDir/chrome/icons/default
    ln -s ../../../icons/default.xpm  $out/lib/$libDir/chrome/icons/default/
    
}

genericBuild
