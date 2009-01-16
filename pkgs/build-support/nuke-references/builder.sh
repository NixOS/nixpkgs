source $stdenv/setup

ensureDir $out/bin
cat > $out/bin/nuke-refs <<EOF
#! $SHELL -e
for i in \$*; do
    if ! test -L \$i; then
        cat \$i | sed "s|/nix/store/[a-z0-9]*-|/nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-|g" > \$i.tmp
        if test -x \$i; then chmod +x \$i.tmp; fi
        mv \$i.tmp \$i
    fi
done
EOF
chmod +x $out/bin/nuke-refs
