. $stdenv/setup

export QTDIR=$qt3

buildPhase=myBuilder
myBuilder() {
    qmake mythtv.pro || fail
    make || fail
}

genericBuild