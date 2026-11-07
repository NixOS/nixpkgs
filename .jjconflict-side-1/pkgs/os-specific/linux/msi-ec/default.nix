{
  stdenv,
  lib,
  fetchFromGitHub,
  linuxPackages,
  git,
  kernel ? linuxPackages.kernel,
  kernelModuleMakeFlags,
}:
stdenv.mkDerivation {
  pname = "msi-ec-kmods";
  version = "0-unstable-2026-08-02";

  src = fetchFromGitHub {
    owner = "BeardOverflow";
    repo = "msi-ec";
    rev = "050d4394a6747ebd106ae2f8ddb3a4eebe7c700f";
    hash = "sha256-b7wwZstjeLPEsxIjmZentDwkQTxdBYbpJfdOR24Ofww=";
  };

  dontMakeSourcesWritable = false;

  patches = [
    ./patches/makefile.patch
    ./patches/kernel-string-choices.patch
  ];

  hardeningDisable = [ "pic" ];

  makeFlags = kernelModuleMakeFlags ++ [
    "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];

  nativeBuildInputs = kernel.moduleBuildDependencies ++ [ git ];

  installTargets = [ "modules_install" ];

  enableParallelBuilding = true;

  meta = {
    description = "Kernel modules for MSI Embedded controller";
    homepage = "https://github.com/BeardOverflow/msi-ec";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.m1dugh ];
    platforms = lib.platforms.linux;
    broken = kernel.kernelOlder "6.5";
  };
}
