{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  autoreconfHook,
  bash,
  fuse3,
  libmspack,
  openssl,
  pam,
  xercesc,
  icu,
  libdnet,
  pciutils,
  procps,
  libtirpc,
  rpcsvc-proto,
  libX11,
  libXext,
  libXinerama,
  libXi,
  libXrender,
  libXrandr,
  libXtst,
  libxcrypt,
  libxml2,
  pkg-config,
  glib,
  gdk-pixbuf-xlib,
  gtk3,
  gtkmm3,
  iproute2,
  dbus,
  systemd,
  which,
  libdrm,
  udev,
  util-linux,
  xmlsec,
  udevCheckHook,
  withX ? true,
}:
let
  inherit (lib)
    licenses
    maintainers
    makeBinPath
    optional
    optionals
    ;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "open-vm-tools";
  version = "13.0.5";

  src = fetchFromGitHub {
    owner = "vmware";
    repo = "open-vm-tools";
    tag = "stable-${finalAttrs.version}";
    hash = "sha256-N0z7OpJP8ubYOeb0KHEQkITlWkKP04rpm79VXRnCe0I=";
  };

  sourceRoot = "${finalAttrs.src.name}/open-vm-tools";

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    autoreconfHook
    makeWrapper
    pkg-config
    udevCheckHook
  ];

  buildInputs = [
    fuse3
    glib
    icu
    libdnet
    libdrm
    libmspack
    libtirpc
    libxcrypt
    libxml2
    openssl
    pam
    procps
    rpcsvc-proto
    udev
    xercesc
    xmlsec
  ]
  ++ optionals withX [
    gdk-pixbuf-xlib
    gtk3
    gtkmm3
    libX11
    libXext
    libXinerama
    libXi
    libXrender
    libXrandr
    libXtst
  ];

  postPatch = ''
    substituteInPlace Makefile.am \
      --replace-fail "etc/vmware-tools" "''${prefix}/etc/vmware-tools"
    substituteInPlace scripts/Makefile.am \
      --replace-fail "confdir = /etc/vmware-tools" "confdir = ''${prefix}/etc/vmware-tools" \
      --replace-fail "/usr/bin" "''${prefix}/bin"
    substituteInPlace services/vmtoolsd/Makefile.am \
      --replace-fail "etc/vmware-tools" "''${prefix}/etc/vmware-tools" \
      --replace-fail "\$(PAM_PREFIX)" "''${prefix}/\$(PAM_PREFIX)"
    substituteInPlace vgauth/service/Makefile.am \
      --replace-fail "/etc/vmware-tools/vgauth/schemas" "''${prefix}/etc/vmware-tools/vgauth/schemas" \
      --replace-fail "\$(DESTDIR)/etc/vmware-tools/vgauth.conf" "''${prefix}/etc/vmware-tools/vgauth.conf"

    # don't abort on any warning
    substituteInPlace configure.ac \
      --replace-fail 'CFLAGS="$CFLAGS -Werror"' ""

    # Make reboot work, shutdown is not in /sbin on NixOS
    substituteInPlace lib/system/systemLinux.c \
      --replace-fail "/sbin/shutdown" "shutdown"

    # Fix paths to fuse3 (we do not use fuse2 so that is not modified)
    substituteInPlace vmhgfs-fuse/config.c \
      --replace-fail "/bin/fusermount3" "${fuse3}/bin/fusermount3"

    # do not break the PATHs set by makeWrapper, sudo resets PATH anyway.
    substituteInPlace scripts/common/vm-support \
      --replace-fail "export PATH=/bin:/sbin:/usr/bin:/usr/sbin" "" \
      --replace-fail ". /etc/profile" ":" \
      --replace-fail "/sbin/lsmod" "lsmod"

    substituteInPlace services/plugins/vix/foundryToolsDaemon.c \
     --replace-fail "/usr/bin/vmhgfs-fuse" "${placeholder "out"}/bin/vmhgfs-fuse" \
     --replace-fail "/bin/mount" "${util-linux}/bin/mount"

    substituteInPlace lib/guestStoreClientHelper/guestStoreClient.c \
      --replace-fail "libguestStoreClient.so.0" "$out/lib/libguestStoreClient.so.0"

    substituteInPlace udev/99-vmware-scsi-udev.rules \
      --replace-fail "/bin/sh" "${bash}/bin/sh"
  '';

  configureFlags = [
    "--without-kernel-modules"
    "--with-udev-rules-dir=${placeholder "out"}/lib/udev/rules.d"
    "--with-fuse=fuse3"
  ]
  ++ optional (!withX) "--without-x";

  enableParallelBuilding = true;

  doInstallCheck = true;

  preConfigure = ''
    mkdir -p ${placeholder "out"}/lib/udev/rules.d
  '';

  postInstall = ''
    wrapProgram "$out/bin/vm-support" \
      --prefix PATH ':' "${
        makeBinPath [
          iproute2
          pciutils # for lspci
          systemd
          which
        ]
      }"

    wrapProgram "$out/etc/vmware-tools/scripts/vmware/network" \
      --prefix PATH ':' "${
        makeBinPath [
          iproute2
          dbus
          systemd
          which
        ]
      }"
  '';

  meta = {
    homepage = "https://github.com/vmware/open-vm-tools";
    changelog = "https://github.com/vmware/open-vm-tools/releases/tag/stable-${finalAttrs.version}";
    description = "Set of tools for VMWare guests to improve host-guest interaction";
    longDescription = ''
      A set of services and modules that enable several features in VMware products for
      better management of, and seamless user interactions with, guests.
    '';
    license = with licenses; [
      gpl2
      lgpl21Only
    ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
      "aarch64-linux"
    ];
    maintainers = with maintainers; [
      joamaki
      kjeremy
    ];
  };
})
