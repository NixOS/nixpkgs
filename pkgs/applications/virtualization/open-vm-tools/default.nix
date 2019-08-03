{ stdenv, lib, fetchFromGitHub, makeWrapper, autoreconfHook,
  fuse, libmspack, openssl, pam, xercesc, icu, libdnet, procps,
  libX11, libXext, libXinerama, libXi, libXrender, libXrandr, libXtst,
  pkgconfig, glib, gtk3, gtkmm3, iproute, dbus, systemd, which,
  withX ? true }:

stdenv.mkDerivation rec {
  name = "open-vm-tools-${version}";
  version = "10.3.10";

  src = fetchFromGitHub {
    owner  = "vmware";
    repo   = "open-vm-tools";
    rev    = "stable-${version}";
    sha256 = "0x2cyccnb4sycrw7r5mzby2d196f9jiph8vyqi0x8v8r2b4vi4yj";
  };

  sourceRoot = "${src.name}/open-vm-tools";

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ autoreconfHook makeWrapper pkgconfig ];
  buildInputs = [ fuse glib icu libdnet libmspack openssl pam procps xercesc ]
      ++ lib.optionals withX [ gtk3 gtkmm3 libX11 libXext libXinerama libXi libXrender libXrandr libXtst ];

  patches = [ ./recognize_nixos.patch ];
  postPatch = ''
     # Build bugfix for 10.1.0, stolen from Arch PKGBUILD
     mkdir -p common-agent/etc/config
     sed -i 's|.*common-agent/etc/config/Makefile.*|\\|' configure.ac

     sed -i 's,^confdir = ,confdir = ''${prefix},' scripts/Makefile.am
     sed -i 's,etc/vmware-tools,''${prefix}/etc/vmware-tools,' services/vmtoolsd/Makefile.am
     sed -i 's,$(PAM_PREFIX),''${prefix}/$(PAM_PREFIX),' services/vmtoolsd/Makefile.am
     sed -i 's,$(UDEVRULESDIR),''${prefix}/$(UDEVRULESDIR),' udev/Makefile.am

     # Avoid a glibc >= 2.25 deprecation warning that gets fatal via -Werror.
     sed 1i'#include <sys/sysmacros.h>' -i lib/wiper/wiperPosix.c

     # Make reboot work, shutdown is not in /sbin on NixOS
     sed -i 's,/sbin/shutdown,shutdown,' lib/system/systemLinux.c
  '';

  configureFlags = [ "--without-kernel-modules" "--without-xmlsecurity" ]
    ++ lib.optional (!withX) "--without-x";

  enableParallelBuilding = true;

  postInstall = ''
    wrapProgram "$out/etc/vmware-tools/scripts/vmware/network" \
      --prefix PATH ':' "${lib.makeBinPath [ iproute dbus systemd which ]}"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/vmware/open-vm-tools;
    description = "Set of tools for VMWare guests to improve host-guest interaction";
    longDescription = ''
      A set of services and modules that enable several features in VMware products for
      better management of, and seamless user interactions with, guests.
    '';
    license = licenses.gpl2;
    platforms =  [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ joamaki ];
  };
}
