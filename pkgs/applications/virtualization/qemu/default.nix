{ stdenv, fetchurl, fetchpatch, python2, zlib, pkgconfig, glib
, ncurses, perl, pixman, vde2, alsaLib, texinfo, flex
, bison, lzo, snappy, libaio, gnutls, nettle, curl
, makeWrapper
, attr, libcap, libcap_ng
, CoreServices, Cocoa, rez, setfile
, numaSupport ? stdenv.isLinux && !stdenv.isArm, numactl
, seccompSupport ? stdenv.isLinux, libseccomp
, pulseSupport ? !stdenv.isDarwin, libpulseaudio
, sdlSupport ? !stdenv.isDarwin, SDL
, vncSupport ? true, libjpeg, libpng
, spiceSupport ? !stdenv.isDarwin, spice, spice-protocol
, usbredirSupport ? spiceSupport, usbredir
, xenSupport ? false, xen
, hostCpuOnly ? false
, nixosTestRunner ? false
}:

with stdenv.lib;
let
  version = "2.11.1";
  sha256 = "1jrcff0szyjxc3vywyiclwdzk0xgq4cxvjbvmcfyjcpdrq9j5pyr";
  audio = optionalString (hasSuffix "linux" stdenv.system) "alsa,"
    + optionalString pulseSupport "pa,"
    + optionalString sdlSupport "sdl,";

  hostCpuTargets = if stdenv.isx86_64 then "i386-softmmu,x86_64-softmmu"
                   else if stdenv.isi686 then "i386-softmmu"
                   else if stdenv.isArm then "arm-softmmu"
                   else if stdenv.isAarch64 then "aarch64-softmmu"
                   else throw "Don't know how to build a 'hostCpuOnly = true' QEMU";
in

stdenv.mkDerivation rec {
  name = "qemu-"
    + stdenv.lib.optionalString xenSupport "xen-"
    + stdenv.lib.optionalString hostCpuOnly "host-cpu-only-"
    + stdenv.lib.optionalString nixosTestRunner "for-vm-tests-"
    + version;

  src = fetchurl {
    url = "http://wiki.qemu.org/download/qemu-${version}.tar.bz2";
    inherit sha256;
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
    ++ optionals sdlSupport [ SDL ]
    ++ optionals vncSupport [ libjpeg libpng ]
    ++ optionals spiceSupport [ spice-protocol spice ]
    ++ optionals usbredirSupport [ usbredir ]
    ++ optionals stdenv.isLinux [ alsaLib libaio libcap_ng libcap attr ]
    ++ optionals xenSupport [ xen ];

  enableParallelBuilding = true;

  patches = [ ./no-etc-install.patch ./statfs-flags.patch (fetchpatch {
    name = "glibc-2.27-memfd.patch";
    url = "https://git.qemu.org/?p=qemu.git;a=patch;h=75e5b70e6b5dcc4f2219992d7cffa462aa406af0";
    sha256 = "0gaz93kb33qc0jx6iphvny0yrd17i8zhcl3a9ky5ylc2idz0wiwa";
  }) ]
    ++ optional nixosTestRunner ./force-uid0-on-9p.patch
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
    (fetchpatch {
      url = https://raw.githubusercontent.com/alpinelinux/aports/61a7a1b77a868e3b940c0b25e6c2b2a6c32caf20/main/qemu/0006-linux-user-signal.c-define-__SIGRTMIN-MAX-for-non-GN.patch;
      sha256 = "1ar6r1vpmhnbs72v6mhgyahcjcf7b9b4xi7asx17sy68m171d2g6";
    })
    (fetchpatch {
      url = https://raw.githubusercontent.com/alpinelinux/aports/2bb133986e8fa90e2e76d53369f03861a87a74ef/main/qemu/fix-sigevent-and-sigval_t.patch;
      sha256 = "0wk0rrcqywhrw9hygy6ap0lfg314m9z1wr2hn8338r5gfcw75mav";
    })
  ];

  hardeningDisable = [ "stackprotector" ];

  preConfigure = ''
    unset CPP # intereferes with dependency calculation
  '';

  configureFlags =
    [ "--smbd=smbd" # use `smbd' from $PATH
      "--audio-drv-list=${audio}"
      "--sysconfdir=/etc"
      "--localstatedir=/var"
    ]
    ++ optional numaSupport "--enable-numa"
    ++ optional seccompSupport "--enable-seccomp"
    ++ optional spiceSupport "--enable-spice"
    ++ optional usbredirSupport "--enable-usb-redir"
    ++ optional hostCpuOnly "--target-list=${hostCpuTargets}"
    ++ optional stdenv.isDarwin "--enable-cocoa"
    ++ optional stdenv.isLinux "--enable-linux-aio"
    ++ optional xenSupport "--enable-xen";

  postFixup =
    ''
      for exe in $out/bin/qemu-system-* ; do
        paxmark m $exe
      done
    '';

  # Add a ‘qemu-kvm’ wrapper for compatibility/convenience.
  postInstall =
    if stdenv.isx86_64       then ''makeWrapper $out/bin/qemu-system-x86_64  $out/bin/qemu-kvm --add-flags "\$([ -e /dev/kvm ] && echo -enable-kvm)"''
    else if stdenv.isi686    then ''makeWrapper $out/bin/qemu-system-i386    $out/bin/qemu-kvm --add-flags "\$([ -e /dev/kvm ] && echo -enable-kvm)"''
    else if stdenv.isArm     then ''makeWrapper $out/bin/qemu-system-arm     $out/bin/qemu-kvm --add-flags "\$([ -e /dev/kvm ] && echo -enable-kvm)"''
    else if stdenv.isAarch64 then ''makeWrapper $out/bin/qemu-system-aarch64 $out/bin/qemu-kvm --add-flags "\$([ -e /dev/kvm ] && echo -enable-kvm)"''
    else "";

  passthru = {
    qemu-system-i386 = "bin/qemu-system-i386";
  };

  meta = with stdenv.lib; {
    homepage = http://www.qemu.org/;
    description = "A generic and open source machine emulator and virtualizer";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ viric eelco ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
