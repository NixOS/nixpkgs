source $stdenv/setup

mkdir -p $out/bin
for i in $binaries
do 
    ln -s "/usr/bin/$i" "$out/bin/"
done

# MIG assumes the standard Darwin core utilities (e.g., `rm -d'), so
# let it see the impure directories.
cat > "$out/bin/mig" <<EOF
#!/bin/sh
export PATH="/usr/bin:/bin:\$PATH"
exec /usr/bin/mig "\$@"
EOF
chmod +x "$out/bin/mig"
