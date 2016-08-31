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
  version = "2.6.1";
  audio = optionalString (hasSuffix "linux" stdenv.system) "alsa,"
    + optionalString pulseSupport "pa,"
    + optionalString sdlSupport "sdl,";
in

stdenv.mkDerivation rec {
  name = "qemu-" + stdenv.lib.optionalString x86Only "x86-only-" + version;

  src = fetchurl {
    url = "http://wiki.qemu.org/download/qemu-${version}.tar.bz2";
    sha256 = "1l88iqk0swqccrnjwczgl9arqsvy77bis862zxajy7z3dqdzshj9";
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
      url = "http://git.qemu.org/?p=qemu.git;a=patch;h=fff39a7ad09da07ef490de05c92c91f22f8002f2";
      name = "9pfs-forbid-illegal-path-names.patch";
      sha256 = "081j85p6m7s1cfh3aq1i2av2fsiarlri9gs939s0wvc6pdyb4b70";
    })
    (fetchpatch {
      url = "http://git.qemu.org/?p=qemu.git;a=patch;h=805b5d98c649d26fc44d2d7755a97f18e62b438a";
      name = "9pfs-forbid-.-and-..-in-file-names.patch";
      sha256 = "0km6knll492dx745gx37bi6dhmz08cmjiyf479ajkykp0aljii24";
    })
    (fetchpatch {
      url = "http://git.qemu.org/?p=qemu.git;a=patch;h=56f101ecce0eafd09e2daf1c4eeb1377d6959261";
      name = "9pfs-directory-traversal-CVE-2016-7116.patch";
      sha256 = "06pr070qj19w5mjxr36bcqxmgpiczncigqsbwfc8ncjhm1h7dmry";
    })
  ];

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
