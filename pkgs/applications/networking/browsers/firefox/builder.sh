source $stdenv/setup

postInstall=postInstall
postInstall() {

    # Strip some more stuff
    strip -S $out/lib/*/* || true

    # This fixes starting Firefox when there already is a running
    # instance.  The `firefox' wrapper script actually expects to be
    # in the same directory as `run-mozilla.sh', apparently.
    cd $out/bin
    mv firefox ../lib/firefox-*/
    ln -s ../lib/firefox-*/firefox .

    # Register extensions etc.
    echo "running firefox -register..."
    (cd $out/lib/firefox-* && LD_LIBRARY_PATH=. ./firefox-bin -register) || false

    echo "running regxpcom..."
    (cd $out/lib/firefox-* && LD_LIBRARY_PATH=. ./regxpcom) || false
    
}

genericBuild
