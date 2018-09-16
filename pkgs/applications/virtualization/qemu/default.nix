{ stdenv, fetchurl, fetchpatch, python2, zlib, pkgconfig, glib
, ncurses, perl, pixman, vde2, alsaLib, texinfo, flex
, bison, lzo, snappy, libaio, gnutls, nettle, curl
, makeWrapper
, attr, libcap, libcap_ng
, CoreServices, Cocoa, rez, setfile
, numaSupport ? stdenv.isLinux && !stdenv.isAarch32, numactl
, seccompSupport ? stdenv.isLinux, libseccomp
, pulseSupport ? !stdenv.isDarwin, libpulseaudio
, sdlSupport ? !stdenv.isDarwin, SDL2
, gtkSupport ? !stdenv.isDarwin && !xenSupport, gtk3, gettext, gnome3
, vncSupport ? true, libjpeg, libpng
, spiceSupport ? !stdenv.isDarwin, spice, spice-protocol
, usbredirSupport ? spiceSupport, usbredir
, xenSupport ? false, xen
, openGLSupport ? sdlSupport, mesa_noglu, epoxy, libdrm
, virglSupport ? openGLSupport, virglrenderer
, smbdSupport ? false, samba
, hostCpuOnly ? false
, nixosTestRunner ? false
}:

with stdenv.lib;
let
  audio = optionalString (hasSuffix "linux" stdenv.hostPlatform.system) "alsa,"
    + optionalString pulseSupport "pa,"
    + optionalString sdlSupport "sdl,";

  hostCpuTargets = if stdenv.isx86_64 then "i386-softmmu,x86_64-softmmu"
                   else if stdenv.isi686 then "i386-softmmu"
                   else if stdenv.isAarch32 then "arm-softmmu"
                   else if stdenv.isAarch64 then "aarch64-softmmu"
                   else throw "Don't know how to build a 'hostCpuOnly = true' QEMU";
in

stdenv.mkDerivation rec {
  version = "3.0.0";
  name = "qemu-"
    + stdenv.lib.optionalString xenSupport "xen-"
    + stdenv.lib.optionalString hostCpuOnly "host-cpu-only-"
    + stdenv.lib.optionalString nixosTestRunner "for-vm-tests-"
    + version;

  src = fetchurl {
    url = "https://wiki.qemu.org/download/qemu-${version}.tar.bz2";
    sha256 = "1s7bm2xhcxbc9is0rg8xzwijx7azv67skq7mjc58spsgc2nn4glk";
  };

  buildInputs =
    [ python2 zlib pkgconfig glib ncurses perl pixman
      vde2 texinfo flex bison makeWrapper lzo snappy
      gnutls nettle curl
    ]
    ++ optionals stdenv.isDarwin [ CoreServices Cocoa rez setfile ]
    ++ optionals seccompSupport [ libseccomp ]
    ++ optionals numaSupport [ numactl ]
    ++ optionals pulseSupport [ libpulseaudio ]
    ++ optionals sdlSupport [ SDL2 ]
    ++ optionals gtkSupport [ gtk3 gettext gnome3.vte ]
    ++ optionals vncSupport [ libjpeg libpng ]
    ++ optionals spiceSupport [ spice-protocol spice ]
    ++ optionals usbredirSupport [ usbredir ]
    ++ optionals stdenv.isLinux [ alsaLib libaio libcap_ng libcap attr ]
    ++ optionals xenSupport [ xen ]
    ++ optionals openGLSupport [ mesa_noglu epoxy libdrm ]
    ++ optionals virglSupport [ virglrenderer ]
    ++ optionals smbdSupport [ samba ];

  enableParallelBuilding = true;

  outputs = [ "out" "ga" ];

  patches = [
    ./no-etc-install.patch
    ./fix-qemu-ga.patch
  ] ++ optional nixosTestRunner ./force-uid0-on-9p.patch
    ++ optional pulseSupport ./fix-hda-recording.patch
    ++ optionals stdenv.hostPlatform.isMusl [
    (fetchpatch {
      url = https://raw.githubusercontent.com/alpinelinux/aports/2bb133986e8fa90e2e76d53369f03861a87a74ef/main/qemu/xattr_size_max.patch;
      sha256 = "1xfdjs1jlvs99hpf670yianb8c3qz2ars8syzyz8f2c2cp5y4bxb";
    })
    (fetchpatch {
      url = https://raw.githubusercontent.com/alpinelinux/aports/2bb133986e8fa90e2e76d53369f03861a87a74ef/main/qemu/musl-F_SHLCK-and-F_EXLCK.patch;
      sha256 = "1gm67v41gw6apzgz7jr3zv9z80wvkv0jaxd2w4d16hmipa8bhs0k";
    })
    ./sigrtminmax.patch
    (fetchpatch {
      url = https://raw.githubusercontent.com/alpinelinux/aports/2bb133986e8fa90e2e76d53369f03861a87a74ef/main/qemu/fix-sigevent-and-sigval_t.patch;
      sha256 = "0wk0rrcqywhrw9hygy6ap0lfg314m9z1wr2hn8338r5gfcw75mav";
    })
  ];

  hardeningDisable = [ "stackprotector" ];

  preConfigure = ''
    unset CPP # intereferes with dependency calculation
  '' + optionalString stdenv.hostPlatform.isMusl ''
    NIX_CFLAGS_COMPILE+=" -D_LINUX_SYSINFO_H"
  '';

  configureFlags =
    [ "--audio-drv-list=${audio}"
      "--sysconfdir=/etc"
      "--localstatedir=/var"
    ]
    # disable sysctl check on darwin.
    ++ optional stdenv.isDarwin "--cpu=x86_64"
    ++ optional numaSupport "--enable-numa"
    ++ optional seccompSupport "--enable-seccomp"
    ++ optional spiceSupport "--enable-spice"
    ++ optional usbredirSupport "--enable-usb-redir"
    ++ optional hostCpuOnly "--target-list=${hostCpuTargets}"
    ++ optional stdenv.isDarwin "--enable-cocoa"
    ++ optional stdenv.isLinux "--enable-linux-aio"
    ++ optional gtkSupport "--enable-gtk"
    ++ optional xenSupport "--enable-xen"
    ++ optional openGLSupport "--enable-opengl"
    ++ optional virglSupport "--enable-virglrenderer"
    ++ optional smbdSupport "--smbd=${samba}/bin/smbd";

  doCheck = false; # tries to access /dev

  postFixup =
    ''
      for exe in $out/bin/qemu-system-* ; do
        paxmark m $exe
      done
      # copy qemu-ga (guest agent) to separate output
      mkdir -p $ga/bin
      cp $out/bin/qemu-ga $ga/bin/
    '';

  # Add a ‘qemu-kvm’ wrapper for compatibility/convenience.
  postInstall =
    if stdenv.isx86_64       then ''makeWrapper $out/bin/qemu-system-x86_64  $out/bin/qemu-kvm --add-flags "\$([ -e /dev/kvm ] && echo -enable-kvm)"''
    else if stdenv.isi686    then ''makeWrapper $out/bin/qemu-system-i386    $out/bin/qemu-kvm --add-flags "\$([ -e /dev/kvm ] && echo -enable-kvm)"''
    else if stdenv.isAarch32 then ''makeWrapper $out/bin/qemu-system-arm     $out/bin/qemu-kvm --add-flags "\$([ -e /dev/kvm ] && echo -enable-kvm)"''
    else if stdenv.isAarch64 then ''makeWrapper $out/bin/qemu-system-aarch64 $out/bin/qemu-kvm --add-flags "\$([ -e /dev/kvm ] && echo -enable-kvm)"''
    else "";

  passthru = {
    qemu-system-i386 = "bin/qemu-system-i386";
  };

  meta = with stdenv.lib; {
    homepage = http://www.qemu.org/;
    description = "A generic and open source machine emulator and virtualizer";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ eelco ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
