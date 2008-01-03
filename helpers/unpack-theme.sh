source $stdenv/setup

ensureDir $out

(cd $out && unpackFile $theme)

themeName=$(cd $out && ls)

for i in $out/$themeName/config/*.cfg; do
    echo "converting $i"
    # Rewrite /etc paths.  Also, the file names
    # config/bootsplash-<RES>.cfg should be <RES>.cfg.
    sed "s^/etc/bootsplash/themes^$out^g" < $i > $out/$themeName/$(basename $i | sed 's^.*-^^')
done

rm $out/$themeName/config/*.cfg

ln -s $themeName $out/default
