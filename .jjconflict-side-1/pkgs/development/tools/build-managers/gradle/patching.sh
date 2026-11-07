extractVersion() {
    local jar version
    local prefix="$1"
    shift
    local candidates="$@"

    jar="$(basename -a $candidates | sort | head -n1)"

    version="${jar#$prefix-}"

    echo "${version%.jar}"
}

autoPatchelfInJar() {
    local file="$1" rpath="$2"
    local work

    work="$(mktemp -dt patching.XXXXXXXXXX)"
    pushd "$work"

    jar xf "$file"
    rm "$file"

    autoPatchelf -- .

    jar cf "$file" .

    popd
}
