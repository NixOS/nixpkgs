{ stdenv, lib }:

let
  inherit (lib)
    boolToString
    elem
    optionalString
    optionals
    ;
  inherit (lib.systems) equals;

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

  machine = name: platform: ''
    [${name}_machine]
    system = '${platform.parsed.kernel.name}'
    cpu_family = '${cpuFamily platform}'
    cpu = '${platform.parsed.cpu.name}'
    endian = ${if platform.isLittleEndian then "'little'" else "'big'"}
  '';

  crossFile =
    withTarget:
    builtins.toFile "cross-file.conf" ''
      [properties]
      bindgen_clang_arguments = ['-target', '${stdenv.hostPlatform.config}']
      needs_exe_wrapper = ${boolToString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform)}

      ${machine "host" stdenv.hostPlatform}${optionalString withTarget "\n${machine "target" stdenv.targetPlatform}"}
      [binaries]
      llvm-config = 'llvm-config-native'
      rust = ['rustc', '-C', 'target-feature=${
        if stdenv.hostPlatform.isStatic then "+" else "-"
      }crt-static', '--target', '${stdenv.hostPlatform.rust.rustcTargetSpec}']
      # Meson refuses to consider any CMake binary during cross compilation if it's
      # not explicitly specified here, in the cross file.
      # https://github.com/mesonbuild/meson/blob/0ed78cf6fa6d87c0738f67ae43525e661b50a8a2/mesonbuild/cmake/executor.py#L72
      cmake = 'cmake'
    '';

  hostFlags = optionals (!equals stdenv.hostPlatform stdenv.buildPlatform) [
    "--cross-file=${crossFile false}"
  ];
  targetFlags =
    if equals stdenv.hostPlatform stdenv.targetPlatform then
      hostFlags
    else
      [ "--cross-file=${crossFile true}" ];

  makeMesonFlags =
    {
      mesonFlags ? [ ],
      configurePlatforms ? [ ],
      ...
    }:
    # As with configure scripts, TARGET is relevant only when requested by
    # the package. Ordinary BUILD tools must retain Meson's native mode.
    (if elem "target" configurePlatforms then targetFlags else hostFlags) ++ mesonFlags;

in
{
  inherit makeMesonFlags;
}
