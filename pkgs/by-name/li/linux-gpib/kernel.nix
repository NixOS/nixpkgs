{
  lib,
  stdenv,
  fetchurl,
  kernel,
  pahole,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "linux-gpib-kernel";
  version = "4.3.7";

  src = fetchurl {
    url = "mirror://sourceforge/project/linux-gpib/linux-gpib%20for%203.x.x%20and%202.6.x%20kernels/${finalAttrs.version}/linux-gpib-${finalAttrs.version}.tar.gz";
    hash = "sha256-s/+BJgaGXIW1iwEqQhim/juC0XfIwKvHlcsi20HzrWg=";
  };

  unpackPhase = ''
    tar xf $src
    tar xf linux-gpib-${finalAttrs.version}/${finalAttrs.pname}-${finalAttrs.version}.tar.gz
  '';

  sourceRoot = "${finalAttrs.pname}-${finalAttrs.version}";

  postPatch = ''
    sed -i 's@/sbin/depmod -A@@g' Makefile
  '';

  buildInputs = [ pahole ] ++ kernel.moduleBuildDependencies;

  makeFlags = [
    "LINUX_SRCDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "LINUX_SSRCDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/source"
  ];

  installFlags = [
    "INSTALL_MOD_PATH=$(out)"
  ];

  meta = {
    description = "Support package for GPIB (IEEE 488) hardware";
    homepage = "https://linux-gpib.sourceforge.io/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fsagbuya ];
    platforms = lib.platforms.linux;
  };
})
