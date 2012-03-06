source $stdenv/setup

mkdir -p $out/bin
for i in ar as c++filt gprof ld nm nmedit ranlib size strings strip dsymutil libtool; do 
    ln -s /usr/bin/$i $out/bin/
done
