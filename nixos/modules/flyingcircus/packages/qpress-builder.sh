source $stdenv/setup

echo "unpacking $src..."
mkdir -p $out/bin
tar xvfa $src -C $out/bin

patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
    $out/bin/qpress
