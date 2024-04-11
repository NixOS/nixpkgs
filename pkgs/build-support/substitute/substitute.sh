source $stdenv/setup

args=

target=$out
if test -n "$dir"; then
    target=$out/$dir/$name
    mkdir -p $out/$dir
fi

substitutionsList=($replacements)

if [[ -v substitutions ]]; then
    eval "substitutionsList+=($substitutions)"
fi

substitute $src $target "${substitutionsList[@]}"

if test -n "$isExecutable"; then
    chmod +x $target
fi

eval "$postInstall"

