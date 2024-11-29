
# First argument: command to run
# Second argument: cache name
# Third argument: argument to command
# Fourth argument: cache type
cached_output () {
    cmd="$1";
    basename="$2";
    arg="$3";
    ext="$4";

    if ! [ -e "cache-${ext//./-}/${basename}.${ext}" ]; then
        mkdir -p "cache-${ext//./-}";
        $cmd $arg > "cache-${ext//./-}/${basename}.${ext}";
    fi;

    cat "cache-${ext//./-}/${basename}.${ext}";
}
