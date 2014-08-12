source $stdenv/setup
set -x

lib=" \
  makemkv-oss-${ver}/out/libdriveio.so.0 \
  makemkv-oss-${ver}/out/libmakemkv.so.1 \
  "

bin=" \
  makemkv-oss-${ver}/out/makemkv \
  makemkv-bin-${ver}/bin/amd64/makemkvcon \
  "

tar xzf ${src_bin}
tar xzf ${src_oss}

(
  cd makemkv-oss-${ver}
  make -f makefile.linux
)

chmod +x ${bin}

libPath="${libPath}:${out}/lib" # XXX: der. This should be in the nix file?

for i in ${bin} ; do
  patchelf \
    --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
    --set-rpath $libPath \
    ${i}
done 

mkdir -p $out/bin
mkdir -p $out/lib
mkdir -p $out/share/MakeMKV
cp ${lib} ${out}/lib
cp ${bin} ${out}/bin
cp makemkv-bin-${ver}/src/share/* $out/share/MakeMKV
