source $stdenv/setup

eval "$preInstall"

args=

target=$out
if test -n "$dir"; then
    target=$out/$dir/$name
    ensureDir $out/$dir
fi

substituteAll $src $target

if test -n "$isExecutable"; then
    chmod +x $target
fi

eval "$postInstall"
