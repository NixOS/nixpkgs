. $stdenv/setup


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
}

genericBuild
