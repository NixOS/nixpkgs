{ lib, fetchurl, dpkg, stdenv, elfutils, libdrm, numactl, ncurses, autoPatchelfHook }:
stdenv.mkDerivation rec {
  name = "scale-${version}";
  version = "1.0.0.0";

  src = fetchurl {
    url = "https://dist.scale-lang.com/scale-free-${version}-Ubuntu22.04.deb";
    hash = "sha256-se05TgjlT/cWImaIramnihPX4y7NHPPnfy6Gax0dcHQ=";
  };

  dontConfigure = true;
  dontBuild = true;

  buildInputs = [
    dpkg
    stdenv.cc.cc.lib # libstdc++.so.6
    elfutils # libelf.so.1
    libdrm # libdrm.so.2
    numactl # libnuma.so.1
    ncurses # libtinfo.so.6
  ];
  nativeBuildInputs = [
    autoPatchelfHook
  ];
  autoPatchelfIgnoreMissingDeps = true;

  unpackPhase = ''
    runHook preUnpack

    pwd
    dpkg-deb -x $src .
    find .

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -R opt/scale/* $out/

    runHook postInstall
  '';

  meta = {
    description = "SCALE - GPGPU programming toolkit that allows CUDA applications to be natively compiled for AMD GPUs.";
    homepage = "https://scale-lang.com/";
    license = lib.licenses.asl20;
    maintainers = [
      lib.maintainers.errnoh
    ];
  };
}
