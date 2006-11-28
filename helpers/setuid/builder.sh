source $stdenv/setup

ensureDir $out/bin

gcc -Wall -O2 -DWRAPPER_DIR=\"$wrapperDir\" $setuidWrapper -o $out/bin/setuid-wrapper

strip -s $out/bin/setuid-wrapper
