{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel ? false,
  kernelModuleMakeFlags ? [ ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cryptodev-linux";
  version = "1.14-unstable-2025-11-04";

  src = fetchFromGitHub {
    owner = "cryptodev-linux";
    repo = "cryptodev-linux";
    rev = "08644db02d43478f802755903212f5ee506af73b";
    hash = "sha256-tYTiyysofO23ApXQbnJF5muTTLv1kKu/nLggGv3ntr4=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;
  hardeningDisable = [ "pic" ];

  makeFlags = kernelModuleMakeFlags ++ [
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
    "prefix=$(out)"
  ];

  meta = {
    description = "Device that allows access to Linux kernel cryptographic drivers";
    homepage = "http://cryptodev-linux.org/";
    maintainers = with lib.maintainers; [ moni ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
