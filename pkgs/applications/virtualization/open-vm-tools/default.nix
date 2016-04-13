{ stdenv, lib, fetchurl, makeWrapper, autoreconfHook,
  libmspack, openssl, pam, xercesc, icu, libdnet, procps,
  xlibsWrapper, libXinerama, libXi, libXrender, libXrandr, libXtst,
  pkgconfig, glib, gtk, gtkmm }:

let
  majorVersion = "9.10";
  minorVersion = "0";
  patchSet = "2476743";
  version = "${majorVersion}.${minorVersion}-${patchSet}";

in stdenv.mkDerivation {
  name = "open-vm-tools-${version}";
  src = fetchurl {
    url = "mirror://sourceforge/project/open-vm-tools/open-vm-tools/stable-${majorVersion}.x/open-vm-tools-${version}.tar.gz";
    sha256 = "15lwayrz9bpx4z12fj616hsn25m997y72licwwz7kms4sx9ssip1";
  };

  buildInputs =
    [ autoreconfHook makeWrapper libmspack openssl pam xercesc icu libdnet procps
      pkgconfig glib gtk gtkmm xlibsWrapper libXinerama libXi libXrender libXrandr libXtst ];

  patchPhase = ''
     sed -i s,-Werror,,g configure.ac
     sed -i 's,^confdir = ,confdir = ''${prefix},' scripts/Makefile.am
     sed -i 's,etc/vmware-tools,''${prefix}/etc/vmware-tools,' services/vmtoolsd/Makefile.am
  '';

  patches = [ ./recognize_nixos.patch ];

  configureFlags = "--without-kernel-modules --without-xmlsecurity";

  meta = with stdenv.lib; {
    homepage = "https://github.com/vmware/open-vm-tools";
    description = "Set of tools for VMWare guests to improve host-guest interaction";
    longDescription = ''
      A set of services and modules that enable several features in VMware products for 
      better management of, and seamless user interactions with, guests. 
    '';
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ joamaki ];
  };
}
