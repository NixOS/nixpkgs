source $stdenv/setup

unpackFile $src 
ensureDir $out
mv eclipse $out/

# Set the dynamic linker and RPATH.
rpath=
for i in $libraries; do
    rpath=$rpath${rpath:+:}$i/lib
done
find $out \( -type f -a -perm +0100 \) \
    -print \
    -exec patchelf --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
    --set-rpath "$rpath" {} \;

# Make a wrapper script so that the proper JDK is found.
# don't use makeWrapper in order to change the last line.

ensureDir $out/bin
cat >> $out/bin/eclipse << EOF
#! /bin/sh -e
export PATH=${jdk}/bin\${PATH:+:}\$PATH
export LD_LIBRARY_PATH=$rpath\${LD_LIBRARY_PATH:+:}\$LD_LIBRARY_PATH
exec \$(dirname \$0)/../eclipse/eclipse $@
EOF
chmod +x $out/bin/eclipse

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
    fi
done
