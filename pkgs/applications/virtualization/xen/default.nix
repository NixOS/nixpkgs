{ stdenv, fetchurl, which, zlib, pkgconfig, SDL, openssl
, libuuid, gettext, ncurses, dev86, iasl, pciutils, bzip2, xz
, lvm2, utillinux, procps, texinfo, perl, pythonPackages }:

with stdenv.lib;

let

  version = "4.0.3";

  libDir = if stdenv.is64bit then "lib64" else "lib";

  # Sources needed to build the stubdoms.

  stubdomSrcs =
    [ { url = http://xenbits.xensource.com/xen-extfiles/lwip-1.3.0.tar.gz;
        sha256 = "13wlr85s1hnvia6a698qpryyy12lvmqw0a05xmjnd0h71ralsbkp";
      }
      { url = http://xenbits.xensource.com/xen-extfiles/zlib-1.2.3.tar.gz;
        sha256 = "0pmh8kifb6sfkqfxc23wqp3f2wzk69sl80yz7w8p8cd4cz8cg58p";
      }
      { url = http://xenbits.xensource.com/xen-extfiles/newlib-1.16.0.tar.gz;
        sha256 = "01rxk9js833mwadq92jx0flvk9jyjrnwrq93j39c2j2wjsa66hnv";
      }
      { url = http://xenbits.xensource.com/xen-extfiles/grub-0.97.tar.gz;
        sha256 = "02r6b52r0nsp6ryqfiqchnl7r1d9smm80sqx24494gmx5p8ia7af";
      }
      { url = http://xenbits.xensource.com/xen-extfiles/pciutils-2.2.9.tar.bz2;
        sha256 = "092v4q478i1gc7f3s2wz6p4xlf1wb4gs5shbkn21vnnmzcffc2pn";
      }
    ];

in 

stdenv.mkDerivation {
  name = "xen-${version}";

  src = fetchurl {
    url = "http://bits.xensource.com/oss-xen/release/${version}/xen-${version}.tar.gz";
    sha256 = "0p4i7mm8cdsr8i9z3dij6nriyvz6la2rhm7jkyk2n8h62nnxi1b5";
  };

  patches =
    [ # Xen looks for headers in /usr/include and for libraries using
      # ldconfig.  Don't do that.
      ./has-header.patch

      # GCC 4.5 compatibility.
      ./gcc-4.5.patch
    ];

  buildInputs =
    [ which zlib pkgconfig SDL openssl libuuid gettext ncurses
      dev86 iasl pciutils bzip2 xz texinfo perl
      pythonPackages.python pythonPackages.wrapPython
    ];

  pythonPath = [ pythonPackages.curses ];

  makeFlags = "PREFIX=$(out) CONFIG_DIR=/etc";

  buildFlags = "xen tools stubdom";

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

      substituteInPlace tools/python/xen/xend/server/BlktapController.py \
        --replace /usr/sbin/tapdisk2 $out/sbin/tapdisk2

      substituteInPlace tools/python/xen/xend/XendQCoWStorageRepo.py \
        --replace /usr/sbin/qcow-create $out/sbin/qcow-create

      substituteInPlace tools/python/xen/remus/save.py \
        --replace /usr/lib/xen/bin/xc_save $out/${libDir}/xen/bin/xc_save

      substituteInPlace tools/python/xen/remus/device.py \
        --replace /usr/lib/xen/bin/imqebt $out/${libDir}/xen/bin/imqebt

      # Allow the location of the xendomains config file to be
      # overriden at runtime.
      substituteInPlace tools/hotplug/Linux/init.d/xendomains \
        --replace 'XENDOM_CONFIG=/etc/sysconfig/xendomains' "" \
        --replace /bin/ls ls

      # Xen's stubdoms need various sources that it usually fetches at
      # build time using wget.  We can't have that.
      ${flip concatMapStrings stubdomSrcs (x: let src = fetchurl x; in ''
        cp ${src} stubdom/${src.name}
      '')}

      # Hack to get `gcc -m32' to work without having 32-bit Glibc headers.
      mkdir -p tools/include/gnu
      touch tools/include/gnu/stubs-32.h
    '';

  postBuild =
    ''
      make -C docs man-pages
    '';

  installPhase =
    ''
      mkdir -p $out
      cp -prvd dist/install/nix/store/*/* $out/
      cp -prvd dist/install/boot $out/boot
      cp -prvd dist/install/etc $out/etc
      cp -dR docs/man1 docs/man5 $out/share/man/
      wrapPythonPrograms
    ''; # */

  meta = {
    homepage = http://www.xen.org/;
    description = "Xen hypervisor and management tools for Dom0";
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
