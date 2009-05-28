source $stdenv/setup

ttys=($ttys)
themes=($themes)

ensureDir $out

default=

for ((n = 0; n < ${#ttys[*]}; n++)); do
    tty=${ttys[$n]}
    theme=${themes[$n]}

    if test "$theme" = "default"; then
        if test -z "$default"; then
            echo "No default theme!"
            exit 1
        fi
        theme=$default
    fi
        
    if test -z "$default"; then default=$theme; fi

    echo "TTY $tty -> $theme"

    themeName=$(cd $theme && ls | grep -v default)

    ln -sfn $theme/$themeName $out/$themeName

    if test -e $out/$tty; then
        echo "Multiple themes defined for the same TTY!"
        exit 1
    fi

    ln -sfn $themeName $out/$tty
    
done
