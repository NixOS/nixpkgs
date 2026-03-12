{ stdenv, lib }:

let
  inherit (lib) boolToString optionals;

  # See https://mesonbuild.com/Reference-tables.html#cpu-families
  cpuFamily =
    platform:
    with platform;
    if isAarch32 then
      "arm"
    else if isx86_32 then
      "x86"
    else if isPower64 then
      "ppc64"
    else if isPower then
      "ppc"
    else
      platform.uname.processor;

  crossFile = builtins.toFile "cross-file.conf" ''
    [properties]
    bindgen_clang_arguments = ['-target', '${stdenv.targetPlatform.config}']
    needs_exe_wrapper = ${boolToString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform)}

    [host_machine]
    system = '${stdenv.targetPlatform.parsed.kernel.name}'
    cpu_family = '${cpuFamily stdenv.targetPlatform}'
    cpu = '${stdenv.targetPlatform.parsed.cpu.name}'
    endian = ${if stdenv.targetPlatform.isLittleEndian then "'little'" else "'big'"}

    [binaries]
    llvm-config = 'llvm-config-native'
    rust = ['rustc', '-C', 'target-feature=${
      if stdenv.targetPlatform.isStatic then "+" else "-"
    }crt-static', '--target', '${stdenv.targetPlatform.rust.rustcTargetSpec}']
    # Meson refuses to consider any CMake binary during cross compilation if it's
    # not explicitly specified here, in the cross file.
    # https://github.com/mesonbuild/meson/blob/0ed78cf6fa6d87c0738f67ae43525e661b50a8a2/mesonbuild/cmake/executor.py#L72
    cmake = 'cmake'
  '';

  crossFlags = optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "--cross-file=${crossFile}"
  ];

  makeMesonFlags =
    {
      mesonFlags ? [ ],
      ...
    }:
    crossFlags ++ mesonFlags;

in
{
  inherit makeMesonFlags;
}
