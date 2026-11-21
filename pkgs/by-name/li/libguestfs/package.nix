{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkg-config,
  autoreconfHook,
  makeWrapper,
  removeReferencesTo,
  libxcrypt,
  ncurses,
  cpio,
  gperf,
  cdrkit,
  qemu,
  pcre2,
  augeas,
  libxml2,
  acl,
  libcap,
  libcap_ng,
  libconfig,
  systemdLibs,
  fuse3,
  yajl,
  libvirt,
  hivex,
  db,
  gmp,
  readline,
  numactl,
  libapparmor,
  json_c,
  getopt,
  perlPackages,
  python3,
  ocamlPackages,
  libtirpc,
  appliance ? null,
  javaSupport ? false,
  jdk,
  zstd,
}:

assert appliance == null || lib.isDerivation appliance;

stdenv.mkDerivation (finalAttrs: {
  pname = "libguestfs";
  version = "1.56.2";

  src = fetchurl {
    url = "https://libguestfs.org/download/${lib.versions.majorMinor finalAttrs.version}-stable/libguestfs-${finalAttrs.version}.tar.gz";
    hash = "sha256-u0SJGnleC3khPO4sSRSVpt1ksh9ydEVZFzDX94kBaJo=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    autoreconfHook
    removeReferencesTo
    cdrkit
    cpio
    getopt
    gperf
    makeWrapper
    pkg-config
    python3
    python3.pkgs.pycodestyle
    qemu
    zstd
  ]
  ++ (with perlPackages; [
    perl
    libintl-perl
    GetoptLong
    ModuleBuild
  ])
  ++ (with ocamlPackages; [
    ocaml
    findlib
  ]);
  buildInputs = [
    libxcrypt
    ncurses
    json_c
    pcre2
    augeas
    libxml2
    acl
    libcap
    libcap_ng
    libconfig
    systemdLibs
    fuse3
    yajl
    libvirt
    gmp
    readline
    hivex
    db
    numactl
    libapparmor
    perlPackages.ModuleBuild
    python3
    libtirpc
    zstd
    ocamlPackages.ocamlbuild
    ocamlPackages.ocaml_libvirt
    ocamlPackages.augeas
    ocamlPackages.ocamlbuild
  ]
  ++ lib.optional javaSupport jdk;

  prePatch = ''
    patchShebangs .
  '';

  postPatch = ''
    # Use the FUSE 3 unmount helper instead of relying on FUSE 2 being installed.
    substituteInPlace fuse/guestunmount.c --replace-fail fusermount fusermount3
  '';

  configureFlags = [
    "--enable-daemon"
    "--enable-install-daemon"
    "--disable-appliance"
    "--with-distro=NixOS"
    "--with-python-installdir=${placeholder "out"}/${python3.sitePackages}"
    "--with-readline"
    "CPPFLAGS=-I${lib.getDev libxml2}/include/libxml2"
    "INSTALL_OCAMLLIB=${placeholder "out"}/lib/ocaml"
    "--with-guestfs-path=${placeholder "out"}/lib/guestfs"
  ]
  ++ lib.optionals (!javaSupport) [ "--without-java" ];

  patches = [
    (fetchpatch {
      name = "libguestfs-fuse3.patch";
      url = "https://salsa.debian.org/libvirt-team/libguestfs/-/raw/debian/1%251.56.2-5/debian/patches/Add-FUSE-3-support.patch";
      hash = "sha256-kbOG80ewMgB03KmUxqBKZ0Ekz292zYD5qsa5n2ZuocE=";
    })
    ./libguestfs-syms.patch
    # Fixes PERL Sys-Guestfs build failure
    ./Revert-perl-Pass-CFLAGS-through-extra_linker_flags.patch
  ];

  createFindlibDestdir = true;

  installFlags = [ "REALLY_INSTALL=yes" ];
  enableParallelBuilding = true;

  outputs = [
    "out"
    "guestfsd"
  ];

  postInstall = ''
    # move guestfsd (the component running in the appliance) to a separate output
    mkdir -p $guestfsd/bin
    mv $out/sbin/guestfsd $guestfsd/bin/guestfsd
    remove-references-to -t $out $guestfsd/bin/guestfsd

    mv "$out/lib/ocaml/guestfs" "$OCAMLFIND_DESTDIR/guestfs"
    for bin in $out/bin/*; do
      wrapProgram "$bin" \
        --prefix PATH     : "$out/bin:${hivex}/bin:${qemu}/bin" \
        --prefix PERL5LIB : "$out/${perlPackages.perl.libPrefix}"
    done
  '';

  postFixup = lib.optionalString (appliance != null) ''
    mkdir -p $out/{lib,lib64}
    ln -s ${appliance} $out/lib64/guestfs
    ln -s ${appliance} $out/lib/guestfs
  '';

  doInstallCheck = appliance != null;
  installCheckPhase = ''
    runHook preInstallCheck

    export HOME=$(mktemp -d) # avoid access to /homeless-shelter/.guestfish

    ${qemu}/bin/qemu-img create -f qcow2 disk1.img 10G

    $out/bin/guestfish <<'EOF'
    add-drive disk1.img
    run
    list-filesystems
    part-disk /dev/sda mbr
    mkfs ext2 /dev/sda1
    list-filesystems
    EOF

    runHook postInstallCheck
  '';

  meta = {
    description = "Tools for accessing and modifying virtual machine disk images";
    license = with lib.licenses; [
      gpl2Plus
      lgpl21Plus
    ];
    homepage = "https://libguestfs.org/";
    changelog = "https://libguestfs.org/guestfs-release-notes-${lib.versions.majorMinor finalAttrs.version}.1.html";
    maintainers = with lib.maintainers; [
      lukts30
    ];
    platforms = lib.platforms.linux;
    # this is to avoid "output size exceeded"
    hydraPlatforms = if appliance != null then appliance.meta.hydraPlatforms else lib.platforms.linux;
  };
})
