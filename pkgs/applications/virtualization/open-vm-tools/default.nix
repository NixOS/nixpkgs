{ stdenv
, lib
, fetchFromGitHub
, makeWrapper
, autoreconfHook
, bash
, fuse3
, libmspack
, openssl
, pam
, xercesc
, icu
, libdnet
, procps
, libtirpc
, rpcsvc-proto
, libX11
, libXext
, libXinerama
, libXi
, libXrender
, libXrandr
, libXtst
, libxcrypt
, libxml2
, pkg-config
, glib
, gdk-pixbuf-xlib
, gtk3
, gtkmm3
, iproute2
, dbus
, systemd
, which
, libdrm
, udev
, util-linux
, xmlsec
, withX ? true
}:

stdenv.mkDerivation rec {
  pname = "open-vm-tools";
  version = "12.2.5";

  src = fetchFromGitHub {
    owner = "vmware";
    repo = "open-vm-tools";
    rev = "stable-${version}";
    hash = "sha256-Aa2OzY3x8yRn/uFaCbbKihpsPueup7doPp5i8I04iaQ=";
  };

  sourceRoot = "${src.name}/open-vm-tools";

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    autoreconfHook
    makeWrapper
    pkg-config
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
  ] ++ lib.optionals withX [
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
    sed -i Makefile.am \
      -e 's,etc/vmware-tools,''${prefix}/etc/vmware-tools,'
    sed -i scripts/Makefile.am \
      -e 's,^confdir = ,confdir = ''${prefix},' \
      -e 's,usr/bin,''${prefix}/usr/bin,'
    sed -i services/vmtoolsd/Makefile.am \
      -e 's,etc/vmware-tools,''${prefix}/etc/vmware-tools,' \
      -e 's,$(PAM_PREFIX),''${prefix}/$(PAM_PREFIX),'
    sed -i vgauth/service/Makefile.am \
      -e 's,/etc/vmware-tools/vgauth/schemas,''${prefix}/etc/vmware-tools/vgauth/schemas,' \
      -e 's,$(DESTDIR)/etc/vmware-tools/vgauth.conf,''${prefix}/etc/vmware-tools/vgauth.conf,'

    # don't abort on any warning
    sed -i 's,CFLAGS="$CFLAGS -Werror",,' configure.ac

    # Make reboot work, shutdown is not in /sbin on NixOS
    sed -i 's,/sbin/shutdown,shutdown,' lib/system/systemLinux.c

    # Fix paths to fuse3 (we do not use fuse2 so that is not modified)
    sed -i 's,/bin/fusermount3,${fuse3}/bin/fusermount3,' vmhgfs-fuse/config.c

    substituteInPlace services/plugins/vix/foundryToolsDaemon.c \
     --replace "/usr/bin/vmhgfs-fuse" "${placeholder "out"}/bin/vmhgfs-fuse" \
     --replace "/bin/mount" "${util-linux}/bin/mount"
  '';

  configureFlags = [
    "--without-kernel-modules"
    "--with-udev-rules-dir=${placeholder "out"}/lib/udev/rules.d"
    "--with-fuse=fuse3"
  ] ++ lib.optional (!withX) "--without-x";

  enableParallelBuilding = true;

  preConfigure = ''
    mkdir -p ${placeholder "out"}/lib/udev/rules.d
  '';

  postInstall = ''
    wrapProgram "$out/etc/vmware-tools/scripts/vmware/network" \
      --prefix PATH ':' "${lib.makeBinPath [ iproute2 dbus systemd which ]}"
    substituteInPlace "$out/lib/udev/rules.d/99-vmware-scsi-udev.rules" --replace "/bin/sh" "${bash}/bin/sh"
  '';

  meta = with lib; {
    homepage = "https://github.com/vmware/open-vm-tools";
    changelog = "https://github.com/vmware/open-vm-tools/releases/tag/stable-${version}";
    description = "Set of tools for VMWare guests to improve host-guest interaction";
    longDescription = ''
      A set of services and modules that enable several features in VMware products for
      better management of, and seamless user interactions with, guests.
    '';
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ joamaki ];
  };
}
