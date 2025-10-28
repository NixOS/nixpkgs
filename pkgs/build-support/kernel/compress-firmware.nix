{
  runCommand,
  lib,
  type ? "zstd",
  zstd,
}:

firmware:

let
  compressor =
    {
      xz = {
        ext = "xz";
        nativeBuildInputs = [ ];
        cmd = file: target: ''xz -9c -T1 -C crc32 --lzma2=dict=2MiB "${file}" > "${target}"'';
      };
      zstd = {
        ext = "zst";
        nativeBuildInputs = [ zstd ];
        cmd = file: target: ''zstd -T1 -19 --long --check -f "${file}" -o "${target}"'';
      };
    }
    .${type} or (throw "Unsupported compressor type for firmware.");

  args = {
    allowedRequisites = [ ];
    inherit (compressor) nativeBuildInputs;
  }
  // lib.optionalAttrs (firmware ? meta) { inherit (firmware) meta; };
in

runCommand "${firmware.name}-${type}" args ''
  mkdir -p $out/lib
  (cd ${firmware} && find lib/firmware -type d -print0) |
      (cd $out && xargs -0 mkdir -v --)
  (cd ${firmware} && find lib/firmware -type f -print0) |
      (cd $out && xargs -0rtP "$NIX_BUILD_CORES" -n1 \
          sh -c '${compressor.cmd "${firmware}/$1" "$1.${compressor.ext}"}' --)
  (cd ${firmware} && find lib/firmware -type l) | while read link; do
      target="$(readlink "${firmware}/$link")"
      if [ -f "${firmware}/$link" ]; then
        ln -vs -- "''${target/^${firmware}/$out}.${compressor.ext}" "$out/$link.${compressor.ext}"
      else
        ln -vs -- "''${target/^${firmware}/$out}" "$out/$link"
      fi
  done

  echo "Checking for broken symlinks:"
  find -L $out -type l -print -execdir false -- '{}' '+'
''
