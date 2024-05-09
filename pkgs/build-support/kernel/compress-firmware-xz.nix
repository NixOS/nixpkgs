{ runCommand, lib }:

firmware:

let
  args = {
    allowedRequisites = [];
  } // lib.optionalAttrs (firmware ? meta) { inherit (firmware) meta; };
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
      if [ -f "${firmware}/$link" ]; then
        ln -vs -- "''${target/^${firmware}/$out}.xz" "$out/$link.xz"
      else
        ln -vs -- "''${target/^${firmware}/$out}" "$out/$link"
      fi
  done

  echo "Checking for broken symlinks:"
  find -L $out -type l -print -execdir false -- '{}' '+'
''
