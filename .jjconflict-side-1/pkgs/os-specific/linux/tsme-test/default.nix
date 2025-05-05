{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation {
  pname = "tsme-test";
  version = "${kernel.version}-unstable-2022-12-07";

  src = fetchFromGitHub {
    owner = "AMDESE";
    repo = "mem-encryption-tests";
    rev = "7abb072ffc50ceb0b4145ae84105ce6c91bd1ff4";
    hash = "sha256-v0KAGlo6ci0Ij1NAiMUK0vWDHBiFnpQG4Er6ArIKncQ=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernelModuleMakeFlags ++ [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    runHook preInstall
    install -Dm644 -t $out/lib/modules/${kernel.modDirVersion}/extra tsme-test.ko
    runHook postInstall
  '';

  meta = {
    description = "Kernel driver to test the status of AMD TSME (Transparent Secure Memory Encryption)";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ lyn ];
    platforms = lib.platforms.linux;
    homepage = "https://github.com/AMDESE/mem-encryption-tests";
  };
}
