{ lib
, stdenv
, fetchurl
, kernel
, pahole
}:

stdenv.mkDerivation (import ./common.nix { inherit fetchurl lib; pname = "linux-gpib-kernel"; } // {

  postPatch = ''
    sed -i 's@/sbin/depmod -A@@g' Makefile
  '';

  buildInputs = [ pahole ] ++ kernel.moduleBuildDependencies;

  makeFlags = [
    "LINUX_SRCDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installFlags = [
    "INSTALL_MOD_PATH=$(out)"
  ];
})
