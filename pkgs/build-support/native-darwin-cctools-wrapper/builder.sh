source $stdenv/setup

ensureDir $out/bin
for i in ar as c++filt gprof ld nm nmedit ranlib size strings strip; do 
    ln -s /usr/bin/$i $out/bin/
done
