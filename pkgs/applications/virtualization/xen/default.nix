{ stdenv, fetchurl, which, zlib, pkgconfig, SDL, openssl, python
, libuuid, gettext, ncurses, dev86, iasl, pciutils, bzip2, xz
, lvm2, utillinux, procps }:

let version = "4.0.1"; in 

stdenv.mkDerivation {
  name = "xen-${version}";

  src = fetchurl {
    url = "http://bits.xensource.com/oss-xen/release/${version}/xen-${version}.tar.gz";
    sha256 = "0ww8j5fa2jxg0zyx7d7z9jyv2j47m8w420sy16w3rf8d80lisvbf";
  };

  patches =
    [ # Xen looks for headers in /usr/include and for libraries using
      # ldconfig.  Don't do that.
      ./has-header.patch
    ];

  buildInputs =
    [ which zlib pkgconfig SDL openssl python libuuid gettext ncurses
      dev86 iasl pciutils bzip2 xz
    ];

  makeFlags = "PREFIX=$(out)";

  buildFlags = "xen tools";

  preBuild =
    ''
      substituteInPlace tools/libfsimage/common/fsimage_plugin.c \
        --replace /usr $out

      substituteInPlace tools/blktap2/lvm/lvm-util.c \
        --replace /usr/sbin/vgs ${lvm2}/sbin/vgs \
        --replace /usr/sbin/lvs ${lvm2}/sbin/lvs

      substituteInPlace tools/hotplug/Linux/network-bridge \
        --replace /usr/bin/logger ${utillinux}/bin/logger

      substituteInPlace tools/xenmon/xenmon.py \
        --replace /usr/bin/pkill ${procps}/bin/pkill

      substituteInPlace tools/xenstat/Makefile \
        --replace /usr/include/curses.h ${ncurses}/include/curses.h

      # Work around a bug in our GCC wrapper: `gcc -MF foo -v' doesn't
      # print the GCC version number properly.
      substituteInPlace xen/Makefile \
        --replace '$(CC) $(CFLAGS) -v' '$(CC) -v'
    '';

  installPhase =
    ''
      cp -prvd dist/install/nix/store/* $out
      cp -prvd dist/install/boot $out/boot
    ''; # */

  postFixup =
    ''
      # Set the Python search path in all Python scripts.
      for fn in $(grep -l '#!.*python' $out/bin/* $out/sbin/*); do
          sed -i "$fn" -e "1 a import sys\nsys.path = ['$out/lib/python2.6/site-packages'] + sys.path"
      done

      # Remove calls to `env'.
      for fn in $(grep -l '#!.*/env.*python' $out/bin/* $out/sbin/*); do
          sed -i "$fn" -e "1 s^/nix/store/.*/env.*python^${python}/bin/python^"
      done
    ''; # */

  meta = {
    homepage = http://www.xen.org/;
    description = "Xen hypervisor and management tools for Dom0";
  };
}
