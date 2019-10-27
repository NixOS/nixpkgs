{ stdenv, fetchurl, fetchpatch, python, zlib, pkgconfig, glib
, ncurses, perl, pixman, vde2, alsaLib, texinfo, flex
, bison, lzo, snappy, libaio, gnutls, nettle, curl
, makeWrapper
, attr, libcap, libcap_ng
, CoreServices, Cocoa, Hypervisor, rez, setfile
, numaSupport ? stdenv.isLinux && !stdenv.isAarch32, numactl
, seccompSupport ? stdenv.isLinux, libseccomp
, pulseSupport ? !stdenv.isDarwin, libpulseaudio
, sdlSupport ? !stdenv.isDarwin, SDL2
, gtkSupport ? !stdenv.isDarwin && !xenSupport, gtk3, gettext, vte
, vncSupport ? true, libjpeg, libpng
, smartcardSupport ? true, libcacard
, spiceSupport ? !stdenv.isDarwin, spice, spice-protocol
, usbredirSupport ? spiceSupport, usbredir
, xenSupport ? false, xen
, cephSupport ? false, ceph
, openGLSupport ? sdlSupport, mesa, epoxy, libdrm
, virglSupport ? openGLSupport, virglrenderer
, smbdSupport ? false, samba
, hostCpuOnly ? false
, hostCpuTargets ? (if hostCpuOnly
                    then (stdenv.lib.optional stdenv.isx86_64 "i386-softmmu"
                          ++ ["${stdenv.hostPlatform.qemuArch}-softmmu"])
                    else null)
, nixosTestRunner ? false
}:

with stdenv.lib;
let
  audio = optionalString (hasSuffix "linux" stdenv.hostPlatform.system) "alsa,"
    + optionalString pulseSupport "pa,"
    + optionalString sdlSupport "sdl,";

in

stdenv.mkDerivation rec {
  version = "4.0.0";
  name = "qemu-"
    + stdenv.lib.optionalString xenSupport "xen-"
    + stdenv.lib.optionalString hostCpuOnly "host-cpu-only-"
    + stdenv.lib.optionalString nixosTestRunner "for-vm-tests-"
    + version;

  src = fetchurl {
    url = "https://wiki.qemu.org/download/qemu-${version}.tar.bz2";
    sha256 = "085g6f75si8hbn94mnnjn1r7ysixn5bqj4bhqwvadj00fhzp2zvd";
  };

  nativeBuildInputs = [ python python.pkgs.sphinx pkgconfig flex bison ];
  buildInputs =
    [ zlib glib ncurses perl pixman
      vde2 texinfo makeWrapper lzo snappy
      gnutls nettle curl
    ]
    ++ optionals stdenv.isDarwin [ CoreServices Cocoa Hypervisor rez setfile ]
    ++ optionals seccompSupport [ libseccomp ]
    ++ optionals numaSupport [ numactl ]
    ++ optionals pulseSupport [ libpulseaudio ]
    ++ optionals sdlSupport [ SDL2 ]
    ++ optionals gtkSupport [ gtk3 gettext vte ]
    ++ optionals vncSupport [ libjpeg libpng ]
    ++ optionals smartcardSupport [ libcacard ]
    ++ optionals spiceSupport [ spice-protocol spice ]
    ++ optionals usbredirSupport [ usbredir ]
    ++ optionals stdenv.isLinux [ alsaLib libaio libcap_ng libcap attr ]
    ++ optionals xenSupport [ xen ]
    ++ optionals cephSupport [ ceph ]
    ++ optionals openGLSupport [ mesa epoxy libdrm ]
    ++ optionals virglSupport [ virglrenderer ]
    ++ optionals smbdSupport [ samba ];

  enableParallelBuilding = true;

  outputs = [ "out" "ga" ];

  patches = [
    ./no-etc-install.patch
    ./fix-qemu-ga.patch
    ./9p-ignore-noatime.patch
    (fetchpatch {
      url = "https://git.qemu.org/?p=qemu.git;a=patch;h=d52680fc932efb8a2f334cc6993e705ed1e31e99";
      name = "CVE-2019-12155.patch";
      sha256 = "0h2q71mcz3gvlrbfkqcgla74jdg73hvzcrwr4max2ckpxx8x9207";
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/q/qemu/1:3.1+dfsg-8+deb10u2/debian/patches/slirp-fix-heap-overflow-in-ip_reass-on-big-packet-input-CVE-2019-14378.patch";
      sha256 = "0f3jabl6x6slpnz5pg6fv1k9vfmrkd482z9vqm3adn6mka8lfimb";
      extraPrefix = "slirp/src/";
      stripLen = 2;
    })
    (fetchpatch {
      url = "https://sources.debian.org/data/main/q/qemu/1:3.1+dfsg-8+deb10u2/debian/patches/qemu-bridge-helper-restrict-interface-name-to-IFNAMSIZ-CVE-2019-13164.patch";
      sha256 = "1ypcdlpg3nap0kg9xkrgrqw33j5ah4j7l4i2cp6d5ap8vrw9nn3l";
    })
  ] ++ optional nixosTestRunner ./force-uid0-on-9p.patch
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
      "--enable-docs"
    ]
    # disable sysctl check on darwin.
    ++ optional stdenv.isDarwin "--cpu=x86_64"
    ++ optional numaSupport "--enable-numa"
    ++ optional seccompSupport "--enable-seccomp"
    ++ optional smartcardSupport "--enable-smartcard"
    ++ optional spiceSupport "--enable-spice"
    ++ optional usbredirSupport "--enable-usb-redir"
    ++ optional (hostCpuTargets != null) "--target-list=${stdenv.lib.concatStringsSep "," hostCpuTargets}"
    ++ optional stdenv.isDarwin "--enable-cocoa"
    ++ optional stdenv.isDarwin "--enable-hvf"
    ++ optional stdenv.isLinux "--enable-linux-aio"
    ++ optional gtkSupport "--enable-gtk"
    ++ optional xenSupport "--enable-xen"
    ++ optional cephSupport "--enable-rbd"
    ++ optional openGLSupport "--enable-opengl"
    ++ optional virglSupport "--enable-virglrenderer"
    ++ optional smbdSupport "--smbd=${samba}/bin/smbd";

  doCheck = false; # tries to access /dev

  postFixup =
    ''
      # copy qemu-ga (guest agent) to separate output
      mkdir -p $ga/bin
      cp $out/bin/qemu-ga $ga/bin/
    '';

  # Add a ‘qemu-kvm’ wrapper for compatibility/convenience.
  postInstall = ''
    if [ -x $out/bin/qemu-system-${stdenv.hostPlatform.qemuArch} ]; then
      makeWrapper $out/bin/qemu-system-${stdenv.hostPlatform.qemuArch} \
                  $out/bin/qemu-kvm \
                  --add-flags "\$([ -e /dev/kvm ] && echo -enable-kvm)"
    fi
  '';

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
