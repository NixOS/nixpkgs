{
  lib,
  stdenv,
  pkgsCross,
  gendef,
  gnumake,
  xxd,
  perl,
  qemu-3dfx-src,
  shortRev,
}:

stdenv.mkDerivation {
  pname = "qemu-3dfx-guest-wrappers-windows";
  version = "unstable-${shortRev}";

  src = qemu-3dfx-src;

  # gendef extracts DLL exports for the cross-link step in the 3dfx and
  # mesa Makefiles. xxd is used by drv/Makefile to decode the prebuilt
  # VxD/SYS .xxd images.
  nativeBuildInputs = [
    gnumake
    gendef
    pkgsCross.mingw32.buildPackages.gcc
    xxd
    perl
  ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    cp -r wrappers wrappers-build
    chmod -R u+w wrappers-build
    cd wrappers-build

    substituteInPlace {3dfx,mesa}/src/Makefile.in \
      --replace-fail 'git rev-parse --short HEAD' 'echo ${shortRev}'

    # Plumb the mingw cross-prefix into CROSS/RC/STRIP/DLLTOOL and drop
    # the MSYSTEM check (we're not under MSYS).
    patchMakefile() {
      sed -i \
        -e 's|^CROSS=$|CROSS=i686-w64-mingw32-|' \
        -e 's|^RC=|RC=$(CROSS)|' \
        -e 's|^STRIP=|STRIP=$(CROSS)|' \
        -e 's|^DLLTOOL=|DLLTOOL=$(CROSS)|' \
        -e '/MSYSTEM/d' \
        "$1"
    }

    for sub in 3dfx mesa; do
      mkdir "$sub/build"
      cp "$sub/src/Makefile.in" "$sub/build/Makefile"
      patchMakefile "$sub/build/Makefile"
    done

    # mesa-only: drop wglinfo.exe (TOOLS=), which would need Windows-side
    # gdi32/opengl32 libs we don't ship.
    sed -i 's|^TOOLS=wglinfo.exe.*|TOOLS=|' mesa/build/Makefile

    make -C 3dfx/build fxlib glide.dll glide2x.dll glide3x.dll exports-check
    make -C mesa/build fxlib opengl32.dll exports-check

    # drv/Makefile xxd-decodes prebuilt VxD/SYS images and compiles
    # instdrv.exe against fxlibnt.o (created above in 3dfx/build).
    make -C 3dfx/drv OUTDIR=build CROSS=i686-w64-mingw32-

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp {mesa,3dfx}/build/*.{dll,vxd,sys,exe} $out

    runHook postInstall
  '';

  meta = {
    description = "kjliew/qemu-3dfx Windows guest wrappers (Glide DLLs, MesaGL DLL, VxD, SYS, INSTDRV)";
    homepage = "https://github.com/kjliew/qemu-3dfx";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ io12 ];
    platforms = lib.platforms.linux;
  };
}
