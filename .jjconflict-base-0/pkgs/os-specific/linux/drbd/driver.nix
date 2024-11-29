{ stdenv, lib, fetchurl, kernel, flex, coccinelle, python3 }:

stdenv.mkDerivation rec {
  name = "drbd-${version}-${kernel.version}";
  version = "9.2.8";

  src = fetchurl {
    url = "https://pkg.linbit.com//downloads/drbd/9/drbd-${version}.tar.gz";
    hash = "sha256-LqK1lPucab7wKvcB4VKGdvBIq+K9XtuO2m0DP5XtK3M=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = [
    kernel.moduleBuildDependencies
    flex
    coccinelle
    python3
  ];

  makeFlags = [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "SPAAS=false"
  ];

  # 6.4 and newer provide a in-tree version of the handshake module https://www.kernel.org/doc/html/v6.4/networking/tls-handshake.html
  installPhase = ''
    runHook preInstall
    install -D drbd/drbd.ko -t $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/block/drbd9
    install -D drbd/drbd_transport_tcp.ko -t $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/block/drbd9
    install -D drbd/drbd_transport_lb-tcp.ko -t $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/block/drbd9
    install -D drbd/drbd_transport_rdma.ko -t $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/block/drbd9
    ${lib.optionalString (lib.versionOlder kernel.version "6.4") ''
      install -D drbd/drbd-kernel-compat/handshake/handshake.ko -t $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/block/drbd9
    ''}
    runHook postInstall
  '';

  postPatch = ''
    patchShebangs .
    substituteInPlace Makefile --replace 'SHELL=/bin/bash' 'SHELL=${builtins.getEnv "SHELL"}'
  '';

  # builder.pl had complained about the same file (drbd.ko.xz) provided by two different packages
  # builder.pl also had complained about different permissions between the files from the two packages
  # The compression is required because the kernel has the CONFIG_MODULE_COMPRESS_XZ option enabled
  postFixup = ''
    for ko in $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/block/drbd9/*.ko; do
      xz --compress -6 --threads=0 $ko
      chmod 0444 $ko.xz
    done
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/LINBIT/drbd";
    description = "LINBIT DRBD kernel module";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ birkb ];
    longDescription = ''
       DRBD is a software-based, shared-nothing, replicated storage solution
       mirroring the content of block devices (hard disks, partitions, logical volumes, and so on) between hosts.
    '';
    broken = lib.versionAtLeast kernel.version "6.8"; # wait until next DRBD release for 6.8 support https://github.com/LINBIT/drbd/issues/87#issuecomment-2059323084
  };
}
