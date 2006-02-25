source $stdenv/setup
source $makeWrapper

unpackFile $src 
ensureDir $out
mv eclipse $out/

# Unpack the jars that contain .so files.
#echo "unpacking some jars..."
#for i in $(find $out -name "*.linux*.jar"); do
#    echo $i
#    cd $(dirname $i) && $jdk/bin/jar -x < $i
#    rm $i
#done

# Set the dynamic linker and RPATH.
rpath=
for i in $libraries; do
    rpath=$rpath${rpath:+:}$i/lib
done
glibc=$(cat $NIX_GCC/nix-support/orig-glibc)
find $out \( -type f -a -perm +0100 \) \
    -print \
    -exec patchelf --interpreter $glibc/lib/ld-linux.so.* \
    --set-rpath "$rpath" {} \;
#find $out \( -type f -a -name "*.so*" \) \
#    -print \
#    -exec patchelf --set-rpath "$rpath" {} \;

# Make a wrapper script so that the proper JDK is found.
makeWrapper $out/eclipse/eclipse $out/bin/eclipse \
    --prefix PATH ":" "$jdk/bin" \
    --prefix LD_LIBRARY_PATH ":" "$rpath"

ensureDir plugin-working-dir
workingdir="$(pwd)/plugin-working-dir"
for plugin in $plugins; do
    if test -e $plugin/install; then
      cd $workingdir
      $plugin/install "$out/eclipse"
      rm -rf $workingdir/*
    else
      # assume that it is a file
      cp $plugin $out/eclipse/plugins
    end
done
