{ runCommand, lib }:

firmware:

let
  args = lib.optionalAttrs (firmware ? meta) { inherit (firmware) meta; };
in

runCommand "${firmware.name}-xz" args ''
  mkdir -p $out/lib
  (cd ${firmware} && find lib/firmware -type d -print0) |
      (cd $out && xargs -0 mkdir -v --)
  (cd ${firmware} && find lib/firmware -type f -print0) |
      (cd $out && xargs -0rtP "$NIX_BUILD_CORES" -n1 \
          sh -c 'xz -9c -T1 -C crc32 --lzma2=dict=2MiB "${firmware}/$1" > "$1.xz"' --)
  (cd ${firmware} && find lib/firmware -type l) | while read link; do
      target="$(readlink "${firmware}/$link")"
      if [ -f $target ]; then
        ln -vs -- "''${target/^${firmware}/$out}.xz" "$out/$link.xz"
      else
        ln -vs -- "''${target/^${firmware}/$out}" "$out/$link"
      fi
  done
''
