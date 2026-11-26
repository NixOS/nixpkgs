args=

target=$out
if test -n "$dir"; then
    target=$out/$dir/$name
    mkdir -p $out/$dir
fi

substitute $src $target "${substitutions[@]}"

if test -n "$isExecutable"; then
    chmod +x $target
fi

eval "$postInstall"
