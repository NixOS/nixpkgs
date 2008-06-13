source $stdenv/setup


# Hack - MythTV's configure searches LD_LIBRARY_PATH for its
# dependencies.
for i in $buildInputs; do
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH${LD_LIBRARY_PATH:+:}$i/lib
done
echo $LD_LIBRARY_PATH


buildPhase=myBuilder
myBuilder() {
    qmake mythtv.pro
    make
}


postInstall=postInstall
postInstall() {
    sqlDir="$out/share/mythtv/sql"
    ensureDir $sqlDir
    cp -p ./database/mc.sql $sqlDir/
}


genericBuild
