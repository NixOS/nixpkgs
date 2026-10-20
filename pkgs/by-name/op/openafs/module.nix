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
    # LINUX: Disable osi_dnlc
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/de32db0b657cf95ab65d5ae5b5ac639eb3caa7ab.patch";
      hash = "sha256-q0AOGpWL1r2hMLQgowMBkfOcEvhXEhXVLe1A/tlawFo=";
    })
    # linux: replace strncpy with strscpy
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/dd1dc35068587ac88bc24199a35878d83fa4113c.patch";
      hash = "sha256-fwzRzS799Y68l29vlzIAmHLda57gToLippgNMKWfWaw=";
    })
    # afs: Introduce and use afs_UserScan()
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/f8469c5694f297b4361520144611f4c8c37fd99f.patch";
      hash = "sha256-+uN0Tc1S3cQD57YMiMTcAVXtaOS8yLPc2JW5lSTiAr8=";
    })
    # LINUX: Grab unixuser refs in osi_proc.c
    (fetchpatch {
      url = "https://github.com/openafs/openafs/commit/b52839f04d91d79b5716c2690ba7f76de990453e.patch";
      hash = "sha256-sEPVyCUzlixoyyM53LGJE36zyiK4l7W1KBsJZLXxTZM=";
    })
    # Linux: Remove excl arg from inode_ops->create()
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/17049/revisions/fbd768a43885fb7211f0e39e2b1805a2ff572f93/patch";
      decode = "base64 -d";
      hash = "sha256-K/xrEtiClGuiTW/GQHzLK/WJihSfsGxTgGECoOr3fgw=";
    })
    # cf: Ensure BTF info is created in tests for Linux
    (fetchpatch {
      url = "https://gerrit.openafs.org/changes/17051/revisions/c2549fee44f3820f102b841ae378a873f8e67edd/patch";
      decode = "base64 -d";
      hash = "sha256-iO84BoCpUgUxgZi1F3f2wbjUFQNksXZVQiyjXziByro=";
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
