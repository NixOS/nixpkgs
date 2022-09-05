{ stdenv, lib, fetchFromGitHub, makeWrapper, autoreconfHook
, bash, fuse3, libmspack, openssl, pam, xercesc, icu, libdnet, procps, libtirpc, rpcsvc-proto
, libX11, libXext, libXinerama, libXi, libXrender, libXrandr, libXtst
, pkg-config, glib, gdk-pixbuf-xlib, gtk3, gtkmm3, iproute2, dbus, systemd, which
, libdrm, udev, util-linux
, withX ? true
}:

stdenv.mkDerivation rec {
  pname = "open-vm-tools";
  version = "12.1.0";

  src = fetchFromGitHub {
    owner  = "vmware";
    repo   = "open-vm-tools";
    rev    = "stable-${version}";
    hash = "sha256-PgrLu0Bm9Vom5WNl43312QFWKojdXDAGn3Nvj4hzPrQ=";
  };

  sourceRoot = "${src.name}/open-vm-tools";

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ autoreconfHook makeWrapper pkg-config ];
  buildInputs = [ fuse3 glib icu libdnet libdrm libmspack libtirpc openssl pam procps rpcsvc-proto udev xercesc ]
      ++ lib.optionals withX [ gdk-pixbuf-xlib gtk3 gtkmm3 libX11 libXext libXinerama libXi libXrender libXrandr libXtst ];

  postPatch = ''
     sed -i 's,etc/vmware-tools,''${prefix}/etc/vmware-tools,' Makefile.am
     sed -i 's,^confdir = ,confdir = ''${prefix},' scripts/Makefile.am
     sed -i 's,usr/bin,''${prefix}/usr/bin,' scripts/Makefile.am
     sed -i 's,etc/vmware-tools,''${prefix}/etc/vmware-tools,' services/vmtoolsd/Makefile.am
     sed -i 's,$(PAM_PREFIX),''${prefix}/$(PAM_PREFIX),' services/vmtoolsd/Makefile.am

     # Avoid a glibc >= 2.25 deprecation warning that gets fatal via -Werror.
     sed 1i'#include <sys/sysmacros.h>' -i lib/wiper/wiperPosix.c

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
    "--without-xmlsecurity"
    "--with-udev-rules-dir=${placeholder "out"}/lib/udev/rules.d"
    "--with-fuse=fuse3"
  ] ++ lib.optional (!withX) "--without-x";

  enableParallelBuilding = true;

  NIX_CFLAGS_COMPILE = builtins.toString [
    # fix build with gcc9
    "-Wno-error=address-of-packed-member"
    "-Wno-error=format-overflow"
  ];

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
    description = "Set of tools for VMWare guests to improve host-guest interaction";
    longDescription = ''
      A set of services and modules that enable several features in VMware products for
      better management of, and seamless user interactions with, guests.
    '';
    license = licenses.gpl2;
    platforms =  [ "x86_64-linux" "i686-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ joamaki ];
  };
}
