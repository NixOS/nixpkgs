{
  lib,
  writeTextFile,
  writeScript,
  supermin,
  fetchpatch,
  fakeroot,
  stdenvNoCC,
  buildEnv,
  runCommand,
  closureInfo,
  buildFHSEnv,

  linux,
  libguestfs,

  bash,
  coreutils,
  gnugrep,
  util-linux,
  kmod,
  file,
  xz,
  zstd,
  ntfs3g,
  fuse3,
  fuse,
  gnutar,
  gnused,
  mdadm,
  findutils,
  iproute2,
  cdrkit,
  gptfdisk,
  mtools,
  parted,
  gawk,
  cpio,
  bzip2,
  acl,
  attr,
  lvm2,
  dosfstools,
  e2fsprogs,
  exfatprogs,
  xfsprogs,
  btrfs-progs,
  lzop,
  procps,
  lsof,
  libxml2,
  binutils,
  diffutils,
  iputils,
  curl,
  dhcpcd,
  eudev,
  fakeNss,
  dockerTools,

  superminExtraArgs ? "--verbose",
  appliancePackages ? [
    libguestfs.guestfsd
    bash
    coreutils
    gnugrep
    util-linux
    iputils
    curl
    dhcpcd
    kmod
    file
    xz
    zstd
    ntfs3g
    fuse3
    fuse
    gnutar
    gnused
    mdadm
    findutils
    iproute2
    cdrkit
    gptfdisk
    mtools
    parted
    gawk
    cpio
    bzip2
    acl
    attr
    lvm2
    dosfstools
    e2fsprogs
    exfatprogs
    xfsprogs
    btrfs-progs
    lzop
    procps
    lsof
    libxml2
    binutils
    diffutils
    eudev
    fakeNss
    dockerTools.caCertificates
  ],
  extraAppliancePackages ? [ ],
}:
let
  stub-pacman = writeTextFile {
    name = "stub-pacman";
    text = ''
      #!/bin/sh
      exit 0
    '';
    executable = true;
    destination = "/bin/pacman";
  };
  supermin2 = supermin.overrideAttrs (previousAttrs: {
    patches = [
      # Fixes /lib/modules/
      (fetchpatch {
        url = "https://github.com/libguestfs/supermin/commit/8effa5a686037ba3c2f8c97753f398b73cc54881.patch";
        hash = "sha256-urOdAUtjybXrp/6Me/5oHjFTGOxSESplh9E4oJ0c5l4=";
      })
    ];
    buildInputs = previousAttrs.buildInputs ++ [
      stub-pacman
      fakeroot
    ];
  });

  appliancePackageEnv = buildEnv {
    name = "appliance-nixosEnv";
    paths = appliancePackages ++ extraAppliancePackages;
  };

  applianceInit =
    runCommand "init"
      {
        nativeBuildInputs = [ gnutar ];
      }
      ''
        tar -xOf ${libguestfs.src} --wildcards '*/appliance/init' > $out
        chmod +x $out
      '';

  applianceRootfsLayout = runCommand "appliance-rootfs-layout" { } ''
    mkdir -p $out/{dev,proc,sys,tmp}

    pushd $out
      # avoid supermin quirk where it would follow FHS bin symlink chain
      ln -s .${appliancePackageEnv}/bin ./bin
      ln -s .${appliancePackageEnv}/bin ./sbin
    popd

    cp ${applianceInit} $out/init

    # must re-create /lib symlink chain 1:1 like they are inside the FHSEnv
    mkdir -p $out/usr/lib64/
    ln -sr $out/usr/lib64/ $out/usr/lib
    ln -sr $out/usr/lib $out/lib

    mkdir -p $out/var/lib/
    mkdir -p $out/var/run/
    mkdir -p $out/run
    mkdir -p $out/etc/udev

    cp -rL ${appliancePackageEnv}/etc/. $out/etc/
    rmdir $out/etc/udev/rules.d
    ln -s ../../${eudev}/var/lib/udev/rules.d $out/etc/udev/rules.d
  '';

  applianceRootfsTarball = runCommand "appliance-rootfs-tarball.tar.gz" { } ''
    ${fakeroot}/bin/fakeroot tar -czvf $out -C ${applianceRootfsLayout}/ .
  '';

  applianceSuperminInputs =
    runCommand "appliance-supermin-inputs"
      {
        nativeBuildInputs = [
          findutils
          gnutar
        ];
      }
      ''
        mkdir -p $out
        export closureInfo=${closureInfo { rootPaths = [ appliancePackageEnv ]; }}
        echo "Processing closure from: $closureInfo"

        echo "Generating hostfiles list..."
        xargs -I % find % -type f < $closureInfo/store-paths > $out/hostfiles

        echo "Generating symlinks list..."
        xargs -I % find % -type l < $closureInfo/store-paths > ./symlinks.list
        echo "Packing symlinks into tarball..."
        tar -czf $out/symlinks.tar.gz --no-recursion -T ./symlinks.list
      '';

  applianceFHS = (
    buildFHSEnv {
      name = "appliance-fhs-builder";
      targetPkgs = p: [
        (writeTextFile {
          name = "arch-release";
          text = "";
          destination = "/etc/arch-release";
        })
        stub-pacman
        supermin2
        p.fakeroot
        p.cpio
        p.gnutar
      ];
      runScript = writeScript "build_appliance.sh" ''
        mkdir input
        export SUPERMIN_KERNEL=${linux}/bzImage
        export SUPERMIN_MODULES=${linux.modules}/lib/modules/${linux.version}/

        ln -s ${applianceRootfsTarball} ./input/base.tar.gz
        ln -s ${applianceSuperminInputs}/hostfiles ./input/hostfiles
        ln -s ${applianceSuperminInputs}/symlinks.tar.gz ./input/symlinks.tar.gz

        fakeroot supermin --build ${superminExtraArgs} input/ -f ext2 -o ./build/
      '';
    }
  );
in
stdenvNoCC.mkDerivation {
  name = "libguestfs-appliance-nixos";
  version = libguestfs.version;

  phases = [
    "buildPhase"
    "installPhase"
  ];

  buildPhase = ''
    ${applianceFHS}/bin/${applianceFHS.name}
  '';

  installPhase = ''
    mv ./build/ $out
    echo "NixOS based appliance" > $out/README.fixed
  '';

  meta = {
    description = "A fixed appliance for libguestfs to use, built from NixOS";
    platforms = lib.platforms.linux;
    hydraPlatforms = [ ];
    maintainers = with lib.maintainers; [ lukts30 ];
    license = lib.licenses.free;
  };
}
