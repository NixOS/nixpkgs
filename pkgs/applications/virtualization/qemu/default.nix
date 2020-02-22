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
  version = "4.2.0";
  pname = "qemu"
    + stdenv.lib.optionalString xenSupport "-xen"
    + stdenv.lib.optionalString hostCpuOnly "-host-cpu-only"
    + stdenv.lib.optionalString nixosTestRunner "-for-vm-tests";

  src = fetchurl {
    url = "https://wiki.qemu.org/download/qemu-${version}.tar.bz2";
    sha256 = "1gczv8hn3wqci86css3mhzrppp3z8vppxw25l08j589k6bvz7x1w";
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
      name = "CVE-2019-15890.patch";
      url = "https://git.qemu.org/?p=libslirp.git;a=patch;h=c59279437eda91841b9d26079c70b8a540d41204";
      sha256 = "1q2rc67mfdz034mk81z9bw105x9zad7n954sy3kq068b1svrf7iy";
      stripLen = 1;
      extraPrefix = "slirp/";
    })
    # patches listed at: https://nvd.nist.gov/vuln/detail/CVE-2020-7039
    (fetchpatch {
      name = "CVE-2020-7039-1.patch";
      url = "https://git.qemu.org/?p=libslirp.git;a=patch;h=2655fffed7a9e765bcb4701dd876e9dab975f289";
      sha256 = "1jh0k3lg3553c2x1kq1kl3967jabhba5gm584wjpmr5mjqk3lnz1";
      stripLen = 1;
      extraPrefix = "slirp/";
      excludes = ["slirp/CHANGELOG.md"];
    })
    (fetchpatch {
      name = "CVE-2020-7039-2.patch";
      url = "https://git.qemu.org/?p=libslirp.git;a=patch;h=82ebe9c370a0e2970fb5695aa19aa5214a6a1c80";
      sha256 = "08ccxcmrhzknnzd1a1q2brszv3a7h02n26r73kpli10b0hn12r2l";
      stripLen = 1;
      extraPrefix = "slirp/";
    })
    (fetchpatch {
      name = "CVE-2020-7039-3.patch";
      url = "https://git.qemu.org/?p=libslirp.git;a=patch;h=ce131029d6d4a405cb7d3ac6716d03e58fb4a5d9";
      sha256 = "18ypj9an2jmsmdn58853rbz42r10587h7cz5fdws2x4635778ibd";
      stripLen = 1;
      extraPrefix = "slirp/";
    })
    # patches listed at: https://nvd.nist.gov/vuln/detail/CVE-2020-7211
    (fetchpatch {
      name = "CVE-2020-7211.patch";
      url = "https://git.qemu.org/?p=libslirp.git;a=patch;h=14ec36e107a8c9af7d0a80c3571fe39b291ff1d4";
      sha256 = "1lc8zabqs580iqrsr5k7zwgkx6qjmja7apwfbc36lkvnrxwfzmrc";
      stripLen = 1;
      extraPrefix = "slirp/";
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
