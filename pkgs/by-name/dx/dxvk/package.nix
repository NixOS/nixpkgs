{
  lib,
  stdenvNoCC,
  overrideCC,
  pkgsCross,
  bash,
}:

stdenvNoCC.mkDerivation (
  finalAttrs:
  let
    useWin32ThreadModel =
      stdenv:
      overrideCC stdenv (
        stdenv.cc.override (old: {
          cc = old.cc.override {
            threadsCross = {
              model = "win32";
              package = null;
            };
          };
        })
      );

    mingw32Stdenv = useWin32ThreadModel pkgsCross.mingw32.stdenv;
    mingwW64Stdenv = useWin32ThreadModel pkgsCross.mingwW64.stdenv;

    dxvk32 =
      if stdenvNoCC.isDarwin then
        pkgsCross.mingw32.dxvk_1.override {
          stdenv = mingw32Stdenv;
          enableMoltenVKCompat = true;
        }
      else
        pkgsCross.mingw32.dxvk_2.override { stdenv = mingw32Stdenv; };

    dxvk64 =
      if stdenvNoCC.isDarwin then
        pkgsCross.mingwW64.dxvk_1.override {
          stdenv = mingwW64Stdenv;
          enableMoltenVKCompat = true;
        }
      else
        pkgsCross.mingwW64.dxvk_2.override { stdenv = mingwW64Stdenv; };
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
        "x86_64-darwin"
        "i686-linux"
        "x86_64-linux"
      ];
    };
  }
)
