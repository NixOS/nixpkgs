{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  linuxPackages,
  kernel ? linuxPackages.kernel,
  dos2unix,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aic8800";
  version = "1.0.7";
  KDIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
  CROSS_COMPILE = "";

  src = fetchurl {
    url = "https://linux.brostrend.com/${finalAttrs.pname}-dkms.deb";
    hash = "sha256-uSHBVrkntJkgTE93WrEUkOj9wGA2t4J/AOYgFf8KYdg="; # Replace with actual hash
  };

  patches = [
    # From: Franck Duriez <franck.lucien.duriez@gmail.com>
    # Date: Sun, 28 Apr 2024 18:45:58 +0200
    (fetchpatch {
      name = "make-CONFIG_RFTEST-n-valid.patch";
      url = "https://raw.githubusercontent.com/darkprof83/aic8800-dkms/refs/heads/master/0001-Make-CONFIG_RFTEST-n-valid.patch";
      hash = "sha256-rcfIbVy79pvq4kznzcx450FY6LrpgMaX96Z/uvbcQVM=";
    })
    # From: Franck Duriez <franck.lucien.duriez@gmail.com>
    # Date: Sun, 28 Apr 2024 18:50:13 +0200
    (fetchpatch {
      name = "fix-DKMS-config.patch";
      url = "https://raw.githubusercontent.com/darkprof83/aic8800-dkms/refs/heads/master/0002-Fix-DKMS-config.patch";
      hash = "sha256-mWsnOtN0XUknKIXuesWTOx5QRAsvelVvlwbYiPUK7ks=";
    })
    # From: Franck Duriez <franck.lucien.duriez@gmail.com>
    # Date: Sun, 28 Apr 2024 20:23:26 +0200
    (fetchpatch {
      name = "fix-kernel-logs.patch";
      url = "https://raw.githubusercontent.com/darkprof83/aic8800-dkms/refs/heads/master/0003-Fix-kernel-logs.patch";
      hash = "sha256-YKg3IYaUALBsNQoT988O6TDj8snn9Ag/V7WBCTaYSeE=";
    })
    # From: darkprof83 <darkprof83@gmail.com>
    # Date: 2025-07-02 16:07:27.081211751 +0500
    (fetchpatch {
      name = "add-archer-tx1u-nano.patch";
      url = "https://raw.githubusercontent.com/darkprof83/aic8800-dkms/refs/heads/master/0005-Add-Archer-TX1U-nano.patch";
      hash = "sha256-elf5QqMG0UITyLvht2pRDHwQ8l+0q5CbtN8HPQaN25s=";
    })
  ];

  nativeBuildInputs = [
    dos2unix
  ]
  ++ kernel.moduleBuildDependencies;

  unpackPhase = ''
    ar x $src
    tar xvzf "data.tar.gz"
    unpackRoot="$(pwd -P)"
    files="$unpackRoot/lib/firmware"
    dest="$out/lib/firmware"
    sourceRoot="$unpackRoot/usr/src/${finalAttrs.pname}-${finalAttrs.version}"
    cd "$sourceRoot"
  '';

  prePatch = ''
    dos2unix */*.{c,h}
    substituteInPlace ./aic_load_fw/aicbluetooth.c \
      --replace /lib/firmware "$out/lib/firmware"
    substituteInPlace ./Makefile \
      --replace /lib/modules/ "${kernel.dev}/lib/modules/" \
      --replace /sbin/depmod \# \
      --replace '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
    substituteInPlace $unpackRoot/lib/udev/rules.d/aic.rules \
      --replace /usr/bin/eject /run/current-system/bin/eject
  '';

  hardeningDisable = [ "pic" ];

  enableParallelBuilding = true;

  buildPhase = ''
    make -C ${finalAttrs.KDIR} -j$NIX_BUILD_CORES M=$(pwd -P) ARCH=${stdenv.hostPlatform.linuxArch} CROSS_COMPILE=${finalAttrs.CROSS_COMPILE} modules
  '';

  installPhase = ''
    moduleOutRoot="$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
    mkdir -p "$moduleOutRoot"
    install -p -m 644 "$sourceRoot/aic_load_fw/aic_load_fw.ko" "$moduleOutRoot"
    install -p -m 644 "$sourceRoot/aic8800_fdrv/aic8800_fdrv.ko" "$moduleOutRoot"
    install -dm 755 "$dest"
    install -dm 755 "$dest/aic8800DC"
    install -dm 755 "$dest/aic8800D80"
    cp -dr --no-preserve=ownership "$files/aic8800DC" "$dest"
    cp -dr --no-preserve=ownership "$files/aic8800D80" "$dest"
  '';

  meta = {
    description = "Kernel modules for BrosTrend AX300 WiFi 6";
    platforms = lib.platforms.linux;
    homepage = "https://linux.brostrend.com/troubleshooting/source-code/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ darkprof83 ];
    broken = kernel.kernelOlder "5.4" || kernel.kernelAtLeast "6.13";
  };
})
