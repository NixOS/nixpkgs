. $stdenv/setup

export QTDIR=$qt3


buildPhase=myBuilder
myBuilder() {
    qmake mythtv.pro || fail
    make || fail
}


postInstall=postInstall
postInstall() {
    sqlDir="$out/share/mythtv/sql"
    ensureDir $sqlDir
    cp -p ./database/mc.sql $sqlDir/
    cp -p ./setup/setup $out/bin/mythsetup
}


genericBuild
