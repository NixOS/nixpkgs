source $stdenv/setup

ensureDir $out/bin
cat > $out/bin/nuke-refs <<EOF
#! $SHELL -e
for i in \$*; do
    if test ! -L \$i -a -f \$i; then
        cat \$i | sed "s|$NIX_STORE/[a-z0-9]*-|$NIX_STORE/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-|g" > \$i.tmp
        if test -x \$i; then chmod +x \$i.tmp; fi
        mv \$i.tmp \$i
    fi
done
EOF
chmod +x $out/bin/nuke-refs
