{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  which,
  autoconf,
  automake,
  flex,
  bison,
  kernel,
  glibc,
  perl,
  libtool_2,
  libkrb5,
}:

let
  inherit (import ./srcs.nix { inherit fetchurl; }) src version;

  modDestDir = "$out/lib/modules/${kernel.modDirVersion}/extra/openafs";
  kernelBuildDir = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

in
stdenv.mkDerivation {
  pname = "openafs";
  version = "${version}-${kernel.modDirVersion}";
  inherit src;

  patches = [
    # Linux: pagevec.h renamed to folio_batch.h
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/d47c438aec49e417066a7bef00bd82078014f5ea.patch";
      hash = "sha256-LPURZovpl6KbigzP4mNjgHvPlXYKY5Pxh8sj9RT2W08=";
    })
    # Linux: Add comment for d_alias configure test
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/fd157926f08d10afe981d85654395bbf083ea7a3.patch";
      hash = "sha256-gJ+ylIEZwJcpTWc5hmIXS/QcxtICqjaEzZsl2QegjhY=";
    })
  ];

  nativeBuildInputs = [
    autoconf
    automake
    flex
    libtool_2
    perl
    which
    bison
  ]
  ++ kernel.moduleBuildDependencies;

  buildInputs = [ libkrb5 ];

  hardeningDisable = [ "pic" ];

  configureFlags = [
    "--with-linux-kernel-build=${kernelBuildDir}"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-gssapi"
  ];

  preConfigure = ''
    patchShebangs .
    for i in `grep -l -R '/usr/\(include\|src\)' .`; do
      echo "Patch /usr/include and /usr/src in $i"
      substituteInPlace $i \
        --replace "/usr/include" "${glibc.dev}/include" \
        --replace "/usr/src" "${kernelBuildDir}"
    done

    ./regen.sh -q
  '';

  buildPhase = ''
    make V=1 only_libafs
  '';

  installPhase = ''
    mkdir -p ${modDestDir}
    cp src/libafs/MODLOAD-*/libafs-${kernel.modDirVersion}.* ${modDestDir}/libafs.ko
    xz -f ${modDestDir}/libafs.ko
  '';

  meta = {
    description = "Open AFS client kernel module";
    homepage = "https://www.openafs.org";
    license = lib.licenses.ipl10;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      andersk
      spacefrogg
    ];
  };
}
