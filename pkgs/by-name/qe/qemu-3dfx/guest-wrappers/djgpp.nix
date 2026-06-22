{
  lib,
  stdenv,
  djgpp,
  gnumake,
  which,
  qemu-3dfx-src,
  shortRev,
}:

stdenv.mkDerivation {
  pname = "qemu-3dfx-guest-wrappers-djgpp";
  version = "unstable-${shortRev}";

  src = qemu-3dfx-src;

  # `which` is required by dxe/Makefile's $(shell which $(CC) | sed ...)
  # auto-derivation of DXE_LD_LIBRARY_PATH.
  nativeBuildInputs = [
    gnumake
    djgpp
    which
  ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    cp -r wrappers wrappers-build
    chmod -R u+w wrappers-build

    substituteInPlace wrappers-build/3dfx/dxe/Makefile \
      --replace-fail 'git rev-parse --short HEAD' 'echo ${shortRev}'

    cd wrappers-build/3dfx
    mkdir build

    # nixpkgs ships djgpp as the i586 cross-toolchain; override DXE_LD_LIBRARY_PATH
    # explicitly because the Makefile's `which $(CC) | sed ...` derivation
    # can produce a wrong path inside the nix-store layout.
    make -C dxe OUTDIR=build X86=i586 \
      DXE_LD_LIBRARY_PATH=${djgpp}/i586-pc-msdosdjgpp/lib

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 build/glide2x.dxe $out/glide2x.dxe
    install -Dm644 build/glide3x.dxe $out/glide3x.dxe

    runHook postInstall
  '';

  meta = {
    description = "kjliew/qemu-3dfx DOS DJGPP guest wrappers (DXE files)";
    homepage = "https://github.com/kjliew/qemu-3dfx";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ io12 ];
    platforms = lib.platforms.linux;
  };
}
