{ stdenv, fetchurl, python, zlib, pkgconfig, glib, ncurses, perl, pixman
, vde2, alsaLib, texinfo, libuuid, flex, bison, lzo, snappy
, libaio, gnutls, nettle
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
  version = "2.6.0";
  audio = optionalString (hasSuffix "linux" stdenv.system) "alsa,"
    + optionalString pulseSupport "pa,"
    + optionalString sdlSupport "sdl,";
in

stdenv.mkDerivation rec {
  name = "qemu-" + stdenv.lib.optionalString x86Only "x86-only-" + version;

  src = fetchurl {
    url = "http://wiki.qemu.org/download/qemu-${version}.tar.bz2";
    sha256 = "1v1lhhd6m59hqgmiz100g779rjq70pik5v4b3g936ci73djlmb69";
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

  patches = [ ./no-etc-install.patch ];

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
