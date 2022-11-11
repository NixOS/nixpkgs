{ runCommand }:

firmware:

runCommand "${firmware.name}-xz" {} ''
  mkdir -p $out/lib
  (cd ${firmware} && find lib/firmware -type d -print0) |
      (cd $out && xargs -0 mkdir -v --)
  (cd ${firmware} && find lib/firmware -type f -print0) |
      (cd $out && xargs -0rtP "$NIX_BUILD_CORES" -n1 \
          sh -c 'xz -9c -T1 -C crc32 --lzma2=dict=2MiB "${firmware}/$1" > "$1.xz"' --)
  (cd ${firmware} && find lib/firmware -type l) | while read link; do
      target="$(readlink "${firmware}/$link")"
      ln -vs -- "''${target/^${firmware}/$out}.xz" "$out/$link.xz"
  done
''
