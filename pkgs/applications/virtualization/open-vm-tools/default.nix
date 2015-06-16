{ stdenv, lib, fetchurl, fetchpatch, makeWrapper, autoconf, automake,
  libmspack, openssl, pam, xercesc, icu, libdnet, procps, 
  x11, libXinerama, libXi, libXrender, libXrandr, libXtst,
  pkgconfig, glib, gtk, gtkmm,
  
  kernel ? null,
}:

let
  majorVersion = "9.10";
  minorVersion = "0";
  patchSet = "2476743";
  version = "${majorVersion}.${minorVersion}-${patchSet}";
  patchBaseUrl = "https://raw.githubusercontent.com/davispuh/open-vm-tools-dkms/0a796b509ab5c99f72e4502396f3bf9906f24642/";

in stdenv.mkDerivation rec {
  name = "open-vm-tools-${version}";
  src = fetchurl {
    url = "mirror://sourceforge/project/open-vm-tools/open-vm-tools/stable-${majorVersion}.x/open-vm-tools-${version}.tar.gz";
    sha256 = "15lwayrz9bpx4z12fj616hsn25m997y72licwwz7kms4sx9ssip1";
  };

  buildInputs = 
    [ autoconf automake makeWrapper libmspack openssl pam xercesc icu libdnet procps
      pkgconfig glib gtk gtkmm x11 libXinerama libXi libXrender libXrandr libXtst ];

  patches = [
    (fetchpatch {
      url = patchBaseUrl + "0001-Fix-vmxnet-module-on-kernels-3.16.patch";
      sha256 = "0z72ffj7prinq4qb9hd4vjy7lwsic1c5rq5isc6ppvhnsmcj7g74";
    })
    (fetchpatch {
      url = patchBaseUrl + "0002-Fix-d_alias-to-d_u.d_alias-for-kernel-3.18.patch";
      sha256 = "1mzd57m86kdxy9zs9jfb20j1mp97fixbxkv4fjbi2sw2ia2n8bdn";
    })
    (fetchpatch {
      url = patchBaseUrl + "0003-Fix-f_dentry-msghdr-kernel-3.19.patch";
      sha256 = "07qbcv77jxqnkamdd0ar7qv8fvxqsdjdv4nfk5qr50bvzgqp1g45";
    })
    (fetchpatch {
      url = patchBaseUrl + "0004-Support-backing-dev-info-kernel-4.0.patch";
      sha256 = "0zqsjskfpi8fbmgqymnxsb35cf9x220rzlymckiyv7yzdgy2avvy";
    })
  ];

  patchFlags = "-d . -Np2";
   
  prePatch = ''
     # Do not treat compile warnings as errors
     sed -i s,-Werror,,g configure.ac
     
     # Do not check that kernel directory exits under lib/modules/.../build
     sed -i '/if test.*LINUXDIR\/kernel/,/fi/d'  configure.ac
     
     # Fix install locations
     sed -i 's,^confdir = ,confdir = ''${prefix},' scripts/Makefile.am
     sed -i 's,etc/vmware-tools,''${prefix}/etc/vmware-tools,' services/vmtoolsd/Makefile.am
  '' + 
   (if kernel != null
    then "sed -i 's,$(MODULES_DIR),$(out)/lib/modules/${kernel.modDirVersion},' modules/Makefile.am"
    else "");

  postPatch = ''
     # Move compat_dentry.h into proper place
     mv modules/linux/vmhgfs/shared/* modules/linux/shared/
  '';

  preConfigure = "autoreconf";
  configureFlags = "--without-xmlsecurity --without-root-privileges " +
    (if kernel != null
     then "--with-linuxdir=${kernel.dev}/lib/modules/${kernel.modDirVersion}" 
     else "--without-kernel-modules");

  meta = with stdenv.lib; {
    homepage = "https://github.com/vmware/open-vm-tools";
    description = "Set of tools for VMWare guests to improve host-guest interaction";
    longDescription = ''
      A set of services and utilities that enable several features in VMware products for 
      better management of, and seamless user interactions with, guests. 
    '';
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ joamaki ];
  };
}
