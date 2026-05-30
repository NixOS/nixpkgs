{
  lib,
  stdenv,
  open-watcom-v2,
  gnumake,
  which,
  qemu-3dfx-src,
  shortRev,
}:

stdenv.mkDerivation {
  pname = "qemu-3dfx-guest-wrappers-watcom";
  version = "unstable-${shortRev}";

  src = qemu-3dfx-src;

  # `which` is required by ovl/Makefile's $(shell dirname `which wcc386`).
  nativeBuildInputs = [
    gnumake
    open-watcom-v2
    which
  ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    cp -r wrappers wrappers-build
    chmod -R u+w wrappers-build

    substituteInPlace wrappers-build/3dfx/ovl/Makefile \
      --replace-fail 'git rev-parse --short HEAD' 'echo ${shortRev}'

    cd wrappers-build/3dfx
    mkdir build
    make -C ovl OUTDIR=build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 build/glide2x.ovl $out/glide2x.ovl

    runHook postInstall
  '';

  meta = {
    description = "kjliew/qemu-3dfx DOS Open-Watcom guest wrapper (GLIDE2X.OVL)";
    homepage = "https://github.com/kjliew/qemu-3dfx";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ io12 ];
    platforms = lib.platforms.linux;
  };
}
