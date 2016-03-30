{ stdenv, fetchurl, python, zlib, pkgconfig, glib, ncurses, perl, pixman
, attr, libcap, vde2, alsaLib, texinfo, libuuid, flex, bison, lzo, snappy
, libseccomp, libaio, libcap_ng, gnutls, nettle, numactl
, makeWrapper
, pulseSupport ? true, libpulseaudio
, sdlSupport ? true, SDL
, vncSupport ? true, libjpeg, libpng
, spiceSupport ? true, spice, spice_protocol, usbredir
, x86Only ? false
}:

with stdenv.lib;
let
  version = "2.5.1";
  audio = optionalString (hasSuffix "linux" stdenv.system) "alsa,"
    + optionalString pulseSupport "pa,"
    + optionalString sdlSupport "sdl,";
in

stdenv.mkDerivation rec {
  name = "qemu-" + stdenv.lib.optionalString x86Only "x86-only-" + version;

  src = fetchurl {
    url = "http://wiki.qemu.org/download/qemu-${version}.tar.bz2";
    sha256 = "0b2xa8604absdmzpcyjs7fix19y5blqmgflnwjzsp1mp7g1m51q2";
  };

  buildInputs =
    [ python zlib pkgconfig glib ncurses perl pixman attr libcap
      vde2 texinfo libuuid flex bison makeWrapper lzo snappy libseccomp
      libcap_ng gnutls nettle numactl
    ]
    ++ optionals pulseSupport [ libpulseaudio ]
    ++ optionals sdlSupport [ SDL ]
    ++ optionals vncSupport [ libjpeg libpng ]
    ++ optionals spiceSupport [ spice_protocol spice usbredir ]
    ++ optionals (hasSuffix "linux" stdenv.system) [ alsaLib libaio ];

  enableParallelBuilding = true;

  patches = [ ./no-etc-install.patch ];

  configureFlags =
    [ "--enable-seccomp"
      "--enable-numa"
      "--smbd=smbd" # use `smbd' from $PATH
      "--audio-drv-list=${audio}"
      "--sysconfdir=/etc"
      "--localstatedir=/var"
    ]
    ++ optional spiceSupport "--enable-spice"
    ++ optional x86Only "--target-list=i386-softmmu,x86_64-softmmu"
    ++ optional (hasSuffix "linux" stdenv.system) "--enable-linux-aio";

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
    platforms = platforms.linux;
  };
}
