source $stdenv/setup


# Hack - MythTV's configure searches LD_LIBRARY_PATH for its
# dependencies.
for i in $pkgs; do
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH${LD_LIBRARY_PATH:+:}$i/lib
done
echo $LD_LIBRARY_PATH


buildPhase() {
    qmake mythtv.pro
    make
}


postInstall() {
    sqlDir="$out/share/mythtv/sql"
    mkdir -p $sqlDir
    cp -p ./database/mc.sql $sqlDir/
}


genericBuild
