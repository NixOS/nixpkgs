bcachefs-tools:
{
  lib,
  stdenv,
  kernelModuleMakeFlags,
  kernel,
  rustPlatform,
}:

stdenv.mkDerivation {
  pname = "bcachefs";
  version = "${kernel.version}-${bcachefs-tools.version}";

  __structuredAttrs = true;
  strictDeps = true;

  src = bcachefs-tools.dkms;

  postPatch = ''
    substituteInPlace src/fs/bcachefs/Makefile \
      --replace-fail '$(objtree)/vmlinux' '${kernel.dev}/vmlinux'
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;

  enableParallelBuilding = true;

  makeFlags = kernelModuleMakeFlags ++ [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=${placeholder "out"}"
    "RUST_LIB_SRC=${rustPlatform.rustLibSrc}"
    # remove references to kernel.dev, which was added by rustc
    "KRUSTFLAGS=--remap-path-prefix=${kernel.dev}/="
  ];

  # Modules are installed compressed, so the generic strip hooks skip them.
  # Strip before compression, like ZFS kernel module does.
  postBuild = ''
    find . -name '*.ko' -print0 | xargs -0 -P$NIX_BUILD_CORES ${stdenv.cc.targetPrefix}strip --strip-debug
  '';

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
      downloadPage
      license
      maintainers
      platforms
      ;

    broken = !(lib.versionAtLeast kernel.version "6.16" && lib.versionOlder kernel.version "7.4");
  };
}
