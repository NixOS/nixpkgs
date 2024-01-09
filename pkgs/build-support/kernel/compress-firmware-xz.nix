{ runCommand, lib }:

firmware:

let
  args = lib.optionalAttrs (firmware ? meta) { inherit (firmware) meta; };
in

runCommand "${firmware.name}-xz" args ''
  # note: `-path` represents a complete path, so just 'lib/firmware/edid' doesn't work
  # note: `'(' -path 'lib/firmware/edid/*' ')'` could be wrapped in an array if we need more rules

  mkdir -p $out/lib
  (cd ${firmware} && find lib/firmware -type d -print0) |
      (cd $out && xargs -0 mkdir -pv --)
  (cd ${firmware} && find lib/firmware -type f -not '(' -path 'lib/firmware/edid/*' ')' -print0) |
      (cd $out && xargs -0rtP "$NIX_BUILD_CORES" -n1 \
          sh -c 'xz -9c -T1 -C crc32 --lzma2=dict=2MiB "${firmware}/$1" > "$1.xz"' --)
  (cd ${firmware} && find lib/firmware -type l -not '(' -path 'lib/firmware/edid/*' ')') | while read link; do
      target="$(readlink "${firmware}/$link")"
      ln -vs -- "''${target/^${firmware}/$out}.xz" "$out/$link.xz"
  done
  (cd ${firmware} && find lib/firmware -type f '(' -path 'lib/firmware/edid/*' ')' -print0) |
      (cd $out && xargs -0rtP "$NIX_BUILD_CORES" -n1 \
          sh -c 'ln -vs -- "${firmware}/$1" "$out/$1"' --)
''
