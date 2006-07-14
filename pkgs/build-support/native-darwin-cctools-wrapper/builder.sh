source $stdenv/setup

ensureDir $out/bin
ln -s /usr/bin/ld /usr/bin/as /usr/bin/ar /usr/bin/ranlib /usr/bin/strip $out/bin
