{ stdenv, fetchurl, fetchpatch, python, zlib, pkgconfig, glib
, ncurses, perl, pixman, vde2, alsaLib, texinfo, libuuid, flex
, bison, lzo, snappy, libaio, gnutls, nettle
, makeWrapper
, attr, libcap, libcap_ng
, CoreServices, Cocoa, rez, setfile
, numaSupport ? stdenv.isLinux, numactl
, seccompSupport ? stdenv.isLinux, libseccomp
, pulseSupport ? !stdenv.isDarwin, libpulseaudio
, sdlSupport ? !stdenv.isDarwin, SDL
, vncSupport ? true, libjpeg, libpng
, spiceSupport ? !stdenv.isDarwin, spice, spice_protocol, usbredir
, x86Only ? false
}:

with stdenv.lib;
let
  version = "2.7.0";
  audio = optionalString (hasSuffix "linux" stdenv.system) "alsa,"
    + optionalString pulseSupport "pa,"
    + optionalString sdlSupport "sdl,";
in

stdenv.mkDerivation rec {
  name = "qemu-" + stdenv.lib.optionalString x86Only "x86-only-" + version;

  src = fetchurl {
    url = "http://wiki.qemu.org/download/qemu-${version}.tar.bz2";
    sha256 = "0lqyz01z90nvxpc3nx4djbci7hx62cwvs5zwd6phssds0sap6vij";
  };

  buildInputs =
    [ python zlib pkgconfig glib ncurses perl pixman
      vde2 texinfo libuuid flex bison makeWrapper lzo snappy
      gnutls nettle
    ]
    ++ optionals stdenv.isDarwin [ CoreServices Cocoa rez setfile ]
    ++ optionals seccompSupport [ libseccomp ]
    ++ optionals numaSupport [ numactl ]
    ++ optionals pulseSupport [ libpulseaudio ]
    ++ optionals sdlSupport [ SDL ]
    ++ optionals vncSupport [ libjpeg libpng ]
    ++ optionals spiceSupport [ spice_protocol spice usbredir ]
    ++ optionals stdenv.isLinux [ alsaLib libaio libcap_ng libcap attr ];

  enableParallelBuilding = true;

  patches = [
    ./no-etc-install.patch
    (fetchpatch {
      url = "https://sources.debian.net/data/main/q/qemu/1:2.7+dfsg-3/debian/patches/net-vmxnet-initialise-local-tx-descriptor-CVE-2016-6836.patch";
      sha256 = "1i01vsxsdwrb5r7i9dmrshal4fvpj2j01cmvfkl5wz3ssq5z02wc";
    })
    (fetchpatch {
      url = "https://sources.debian.net/data/main/q/qemu/1:2.7+dfsg-3/debian/patches/scsi-mptconfig-fix-an-assert-expression-CVE-2016-7157.patch";
      sha256 = "1wqf9k79wdr1k25siyhhybz1bpb0iyshv6fvsf55pgk5p0dg1970";
    })
    (fetchpatch {
      url = "https://sources.debian.net/data/main/q/qemu/1:2.7+dfsg-3/debian/patches/scsi-mptconfig-fix-misuse-of-MPTSAS_CONFIG_PACK-CVE-2016-7157.patch";
      sha256 = "0l78fcbq8mywlgax234dh4226kxzbdgmarz1yrssaaiipkzq4xgw";
    })
    (fetchpatch {
      url = "https://sources.debian.net/data/main/q/qemu/1:2.7+dfsg-3/debian/patches/scsi-mptsas-use-g_new0-to-allocate-MPTSASRequest-obj-CVE-2016-7423.patch";
      sha256 = "14l8w40zjjhpmzz4rkh69h5na8d4did7v99ng7nzrychakd5l29h";
    })
    (fetchpatch {
      url = "https://sources.debian.net/data/main/q/qemu/1:2.7+dfsg-3/debian/patches/scsi-pvscsi-check-page-count-while-initialising-descriptor-rings-CVE-2016-7155.patch";
      sha256 = "1dwkci5mqgx3xz2q69kbcn48l8vwql9g3qaza2jxi402xdgc07zn";
    })
    (fetchpatch {
      url = "https://sources.debian.net/data/main/q/qemu/1:2.7+dfsg-3/debian/patches/scsi-pvscsi-limit-loop-to-fetch-SG-list-CVE-2016-7156.patch";
      sha256 = "1r5xm4m9g39p89smsia4i9jbs32nq9gdkpx6wgd91vmswggcbqsi";
    })
    (fetchpatch {
      url = "https://sources.debian.net/data/main/q/qemu/1:2.7+dfsg-3/debian/patches/scsi-pvscsi-limit-process-IO-loop-to-ring-size-CVE-2016-7421.patch";
      sha256 = "07661d1kd0ddkmzsrjph7jnhz2qbfavkxamnvs3axaqpp52kx6ga";
    })
    (fetchpatch {
      url = "https://sources.debian.net/data/main/q/qemu/1:2.7+dfsg-3/debian/patches/usb-xhci-fix-memory-leak-in-usb_xhci_exit-CVE-2016-7466.patch";
      sha256 = "0nckwzn9k6369vni12s8hhjn73gbk6ns0mazns0dlgcq546q2fjj";
    })
    (fetchpatch {
      url = "https://sources.debian.net/data/main/q/qemu/1:2.7+dfsg-3/debian/patches/virtio-add-check-for-descriptor-s-mapped-address-CVE-2016-7422.patch";
      sha256 = "1f1ilpzlxfjqvwmv9h0mzygwl5l8zd690f32vxfv9g6rfbr5h72k";
    })
    (fetchpatch {
      name = "qemu-CVE-2016-8909.patch";
      url = "http://git.qemu.org/?p=qemu.git;a=patch;h=0c0fc2b5fd534786051889459848764edd798050";
      sha256 = "0mavkajxchfacpl4gpg7dhppbnhs1bbqn2rwqwiwkl0m5h19d9fv";
    })
    (fetchpatch {
      name = "qemu-CVE-2016-8910.patch";
      url = "http://git.qemu.org/?p=qemu.git;a=patch;h=c7c35916692fe010fef25ac338443d3fe40be225";
      sha256 = "10qmlggifdmvj5hg3brs712agjq6ppnslm0n5d5jfgjl7599wxml";
    })
    (fetchpatch {
      name = "qemu-CVE-2016-9103.patch";
      url = "http://git.qemu.org/?p=qemu.git;a=patch;h=eb687602853b4ae656e9236ee4222609f3a6887d";
      sha256 = "0j20n4z1wzybx8m7pn1zsxmz4rbl8z14mbalfabcjdgz8sx8g90d";
    })
    (fetchpatch {
      name = "qemu-CVE-2016-9104.patch";
      url = "http://git.qemu.org/?p=qemu.git;a=patch;h=7e55d65c56a03dcd2c5d7c49d37c5a74b55d4bd6";
      sha256 = "1l99sf70098l6v05dq4x7p2glxx1l4nq1l8l3711ykp9vxkp91qs";
    })
    (fetchpatch {
      name = "qemu-CVE-2016-9105.patch";
      url = "http://git.qemu.org/?p=qemu.git;a=patch;h=4c1586787ff43c9acd18a56c12d720e3e6be9f7c";
      sha256 = "0b2w5myw2vjqk81wm8dz373xfhfkx3hgy7bxr94l060snxcl7ar4";
    })
    (fetchpatch {
      name = "qemu-CVE-2016-9106.patch";
      url = "http://git.qemu.org/?p=qemu.git;a=patch;h=fdfcc9aeea1492f4b819a24c94dfb678145b1bf9";
      sha256 = "0npi3fag52icq7xr799h5zi11xscbakdhqmdab0kyl6q331cc32z";
    })
    (fetchpatch {
      name = "qemu-CVE-2016-7994.patch";
      url = "http://git.qemu.org/?p=qemu.git;a=patch;h=cb3a0522b694cc5bb6424497b3f828ccd28fd1dd";
      sha256 = "1zhmbqlj0hc69ia4s6h59pi1z3nmijkryxwmf4bzp9gahx8x4xm3";
    })
    (fetchpatch {
      name = "qemu-CVE-2016-8668.patch";
      url = "http://git.qemu.org/?p=qemu.git;a=patch;h=8caed3d564672e8bc6d2e4c6a35228afd01f4723";
      sha256 = "19sq6fh7nh8wrk52skky4vwm80029lhm093g11f539krmzjgipik";
    })

    # FIXME: Fix for CVE-2016-9101 not yet ready: https://lists.gnu.org/archive/html/qemu-devel/2016-10/msg03024.html

    # from http://git.qemu.org/?p=qemu.git;a=patch;h=ff55e94d23ae94c8628b0115320157c763eb3e06
    ./CVE-2016-9102.patch
  ];
  hardeningDisable = [ "stackprotector" ];

  configureFlags =
    [ "--smbd=smbd" # use `smbd' from $PATH
      "--audio-drv-list=${audio}"
      "--sysconfdir=/etc"
      "--localstatedir=/var"
    ]
    ++ optional numaSupport "--enable-numa"
    ++ optional seccompSupport "--enable-seccomp"
    ++ optional spiceSupport "--enable-spice"
    ++ optional x86Only "--target-list=i386-softmmu,x86_64-softmmu"
    ++ optional stdenv.isDarwin "--enable-cocoa"
    ++ optional stdenv.isLinux "--enable-linux-aio";

  postFixup =
    ''
      for exe in $out/bin/qemu-system-* ; do
        paxmark m $exe
      done
    '';

  postInstall =
    ''
      # Add a ‘qemu-kvm’ wrapper for compatibility/convenience.
      p="$out/bin/qemu-system-${if stdenv.system == "x86_64-linux" then "x86_64" else "i386"}"
      if [ -e "$p" ]; then
        makeWrapper "$p" $out/bin/qemu-kvm --add-flags "\$([ -e /dev/kvm ] && echo -enable-kvm)"
      fi
    '';

  meta = with stdenv.lib; {
    homepage = http://www.qemu.org/;
    description = "A generic and open source machine emulator and virtualizer";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ viric eelco ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
