{
  lib,
  stdenvNoCC,
  pkgsCross,
  bash,
}:

stdenvNoCC.mkDerivation (
  finalAttrs:
  let
    # No threading library apart from the libc, which on MinGW means the
    # `win32` model. With GCC NG in the cross case there are multiple packages
    # consuming `threads` in multiple package sets spliced together, so we are
    # best off with an overlay rather than extending scopes or overriding
    # single packages.
    useWin32ThreadModel =
      pkgs:
      pkgs.appendOverlays [
        (final: prev: { threads = null; })
      ];

    pkgsMingw32 = useWin32ThreadModel pkgsCross.mingw-msvcrt-i686;
    pkgsMingwW64 = useWin32ThreadModel pkgsCross.mingw-msvcrt-x86_64;

    dxvk32 =
      if stdenvNoCC.hostPlatform.isDarwin then
        pkgsMingw32.dxvk_1.override { enableMoltenVKCompat = true; }
      else
        pkgsMingw32.dxvk_3;

    dxvk64 =
      if stdenvNoCC.hostPlatform.isDarwin then
        pkgsMingwW64.dxvk_1.override { enableMoltenVKCompat = true; }
      else
        pkgsMingwW64.dxvk_3;
  in
  {
    pname = "dxvk";
    inherit (dxvk64) version;

    outputs = [
      "out"
      "bin"
      "lib"
    ];

    strictDeps = true;

    buildCommand = ''
      mkdir -p $out/bin $bin $lib
      substitute ${./setup_dxvk.sh} $out/bin/setup_dxvk.sh \
        --subst-var-by bash ${bash} \
        --subst-var-by dxvk32 ${dxvk32} \
        --subst-var-by dxvk64 ${dxvk64} \
        --subst-var-by version ${finalAttrs.version}
      chmod a+x $out/bin/setup_dxvk.sh
      declare -A dxvks=( [x32]=${dxvk32} [x64]=${dxvk64} )
      for arch in "''${!dxvks[@]}"; do
        ln -s "''${dxvks[$arch]}/bin" $bin/$arch
        ln -s "''${dxvks[$arch]}/lib" $lib/$arch
      done
    '';

    passthru = {
      inherit dxvk32 dxvk64;
    };

    __structuredAttrs = true;

    meta = {
      description = "Setup script for DXVK";
      mainProgram = "setup_dxvk.sh";
      homepage = "https://github.com/doitsujin/dxvk";
      changelog = "https://github.com/doitsujin/dxvk/releases";
      maintainers = [ lib.maintainers.reckenrode ];
      license = lib.licenses.zlib;
      platforms = [
        "i686-linux"
        "x86_64-linux"
      ];
    };
  }
)
