{ runCommandLocal,
  composable_kernel_build,
  zstd
}:
let
  ck = composable_kernel_build;
in runCommandLocal "unpack-${ck.name}" {
    nativeBuildInputs = [ zstd ];
    meta = ck.meta;
  } ''
    mkdir -p $out
    cp -r --no-preserve=mode ${ck}/* $out
    zstd -dv --rm $out/lib/libdevice_operations.a.zst -o $out/lib/libdevice_operations.a
    substituteInPlace $out/lib/cmake/composable_kernel/*.cmake \
      --replace "${ck}" "$out"
  ''
