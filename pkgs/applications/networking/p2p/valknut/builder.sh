addInputsHook=addBzip2
addBzip2() {
    bzip2=$(type -tP bzip2)
    test -n $bzip2
    buildInputs="$(dirname $(dirname $bzip2)) $buildInputs"
}

source $stdenv/setup

export configureFlags="--with-ssl-dir=$openssl --x-libraries=/no-such-dir"

genericBuild
