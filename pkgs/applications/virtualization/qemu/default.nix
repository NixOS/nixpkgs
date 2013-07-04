{ stdenv, fetchurl, python, zlib, pkgconfig, glib, ncurses, perl, pixman
, attr, libcap, vde2, alsaLib, texinfo, libuuid
, sdlSupport ? true, SDL
, vncSupport ? true, libjpeg, libpng
, spiceSupport ? false, spice, spice_protocol
}:

stdenv.mkDerivation rec {
  name = "qemu-1.5.1";

  src = fetchurl {
    url = "http://wiki.qemu.org/download/${name}.tar.bz2";
    sha256 = "1s7316pgizpayr472la8p8a4vhv7ymmzd5qlbkmq6y9q5zpa25ac";
  };

  buildInputs =
    [ python zlib pkgconfig glib ncurses perl pixman attr libcap
      vde2 alsaLib texinfo libuuid
    ]
    ++ stdenv.lib.optionals sdlSupport [ SDL ]
    ++ stdenv.lib.optionals vncSupport [ libjpeg libpng ]
    ++ stdenv.lib.optionals spiceSupport [ spice_protocol spice ];

  enableParallelBuilding = true;

  configureFlags =
    [ "--audio-drv-list=alsa"
      "--smbd=smbd" # use `smbd' from $PATH
    ]
    ++ stdenv.lib.optional spiceSupport "--enable-spice";

  meta = {
    homepage = http://www.qemu.org/;
    description = "A generic and open source machine emulator and virtualizer";
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [ viric shlevy eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
