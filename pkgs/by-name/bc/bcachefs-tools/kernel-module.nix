bcachefs-tools:
{
  lib,
  stdenv,
  kernelModuleMakeFlags,
  kernel,
}:

stdenv.mkDerivation {
  pname = "bcachefs";
  version = "${kernel.version}-${bcachefs-tools.version}";

  __structuredAttrs = true;

  src = bcachefs-tools.dkms;

  nativeBuildInputs = kernel.moduleBuildDependencies;

  enableParallelBuilding = true;

  makeFlags = kernelModuleMakeFlags ++ [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];

  installPhase = ''
    runHook preInstall
    make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build M=$(pwd) modules_install "''${makeFlags[@]}" "''${installFlags[@]}"
    runHook postInstall
  '';

  passthru = {
    inherit (bcachefs-tools.passthru) tests;
  };

  meta = {
    description = "out-of-tree bcachefs kernel module";

    inherit (bcachefs-tools.meta)
      homepage
      license
      maintainers
      platforms
      ;

    broken = !(lib.versionAtLeast kernel.version "6.16" && lib.versionOlder kernel.version "6.18");
  };
}
