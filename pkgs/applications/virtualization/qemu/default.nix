{ stdenv, fetchurl, fetchpatch, python2, zlib, pkgconfig, glib
, ncurses, perl, pixman, vde2, alsaLib, texinfo, flex
, bison, lzo, snappy, libaio, gnutls, nettle, curl
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
, nixosTestRunner ? false
}:

with stdenv.lib;
let
  version = "2.8.0";
  audio = optionalString (hasSuffix "linux" stdenv.system) "alsa,"
    + optionalString pulseSupport "pa,"
    + optionalString sdlSupport "sdl,";
in

stdenv.mkDerivation rec {
  name = "qemu-"
    + stdenv.lib.optionalString x86Only "x86-only-"
    + stdenv.lib.optionalString nixosTestRunner "for-vm-tests-"
    + version;

  src = fetchurl {
    url = "http://wiki.qemu.org/download/qemu-${version}.tar.bz2";
    sha256 = "0qjy3rcrn89n42y5iz60kgr0rrl29hpnj8mq2yvbc1wrcizmvzfs";
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
    ++ optionals spiceSupport [ spice_protocol spice usbredir ]
    ++ optionals stdenv.isLinux [ alsaLib libaio libcap_ng libcap attr ];

  enableParallelBuilding = true;

  patches = [
    ./no-etc-install.patch

    (fetchurl {
      name = "CVE-2017-2615.patch";
      url = "http://git.qemu-project.org/?p=qemu.git;a=patch;h=62d4c6bd5263bb8413a06c80144fc678df6dfb64";
      sha256 = "0miph2x4d474issa44hmc542zxmkc7lsr4ncb7pwarq6j7v52l8h";
    })

    (fetchurl {
      name = "CVE-2017-5667.patch";
      url = "http://git.qemu-project.org/?p=qemu.git;a=patch;h=42922105beb14c2fc58185ea022b9f72fb5465e9";
      sha256 = "049vq70is3fj9bf4ysfj3s44iz93qhyqn6xijck32w1x6yyzqyx4";
     })

    (fetchurl {
      name = "CVE-2017-5898.patch";
      url = "http://git.qemu-project.org/?p=qemu.git;a=patch;h=c7dfbf322595ded4e70b626bf83158a9f3807c6a";
      sha256 = "1y2j0qw04s8fl0cs8i619y08kj75lxn3c0y19g710fzpk3rq8dvn";
     })

    (fetchurl {
      name = "CVE-2017-5931.patch";
      url = "http://git.qemu-project.org/?p=qemu.git;a=patch;h=a08aaff811fb194950f79711d2afe5a892ae03a4";
      sha256 = "0hlih9jhbb1mb174hvxs7pf7lgcs7s9g705ri9rliw7wrhqdpja5";
     })

    (fetchurl {
      name = "CVE-2017-5973.patch";
      url = "http://git.qemu-project.org/?p=qemu.git;a=patch;h=f89b60f6e5fee3923bedf80e82b4e5efc1bb156b";
      sha256 = "06niyighjxb4p5z2as3mqfmrwrzn4sq47j7raipbq9gnda7x9sw6";
     })

  ] ++ optional nixosTestRunner ./force-uid0-on-9p.patch;

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
