source $stdenv/setup

ttys=($ttys)
themes=($themes)

mkdir -p $out

defaultName=$(cd $default && ls | grep -v default)
echo $defaultName
ln -s $default/$defaultName $out/$defaultName
ln -s $defaultName $out/default

for ((n = 0; n < ${#ttys[*]}; n++)); do
    tty=${ttys[$n]}
    theme=${themes[$n]}

    echo "TTY $tty -> $theme"

    if [ "$theme" != default ]; then
        themeName=$(cd $theme && ls | grep -v default)
        ln -sfn $theme/$themeName $out/$themeName
    else
        themeName=default
    fi

    if test -e $out/$tty; then
        echo "Multiple themes defined for the same TTY!"
        exit 1
    fi

    ln -sfn $themeName $out/$tty
done
