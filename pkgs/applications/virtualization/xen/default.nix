{ stdenv, fetchurl, which, zlib, pkgconfig, SDL, openssl
, libuuid, gettext, ncurses, dev86, iasl, pciutils, bzip2
, lvm2, utillinux, procps, texinfo, perl, pythonPackages
, glib, bridge_utils, xlibs, pixman, iproute, udev, bison
, flex, cmake, ocaml, ocamlPackages, figlet, libaio, yajl
, checkpolicy, transfig, glusterfs, fetchgit, xz }:

with stdenv.lib;

let
  version = "4.4.1";

  libDir = if stdenv.is64bit then "lib64" else "lib";

  # Sources needed to build the xen tools and tools/firmware.
  toolsGits =
    [ # tag qemu-xen-4.4.1
      #{ name = "qemu-xen";
      #  url = git://xenbits.xen.org/qemu-upstream-4.4-testing.git;
      #  rev = "65fc9b78ba3d868a26952db0d8e51cecf01d47b4";
      #  sha256 = "e7abaf0e927f7a2bba4c59b6dad6ae19e77c92689c94fa0384e2c41742f8cdb6";
      #}
      # tag xen-4.4.1
      {  name = "qemu-xen-traditional";
        url = git://xenbits.xen.org/qemu-xen-4.4-testing.git;
        rev = "6ae4e588081620b141071eb010ec40aca7e12876";
        sha256 = "b1ed1feb92fbe658273a8d6d38d6ea60b79c1658413dd93979d6d128d8554ded";
      }
    ];
  firmwareGits =
    [ # tag 1.7.3.1
      { name = "seabios";
        url = git://xenbits.xen.org/seabios.git;
        rev = "7d9cbe613694924921ed1a6f8947d711c5832eee";
        sha256 = "c071282bbcb1dd0d98536ef90cd1410f5d8da19648138e0e3863bc540d954a87";
      }
      { name = "ovmf";
        url = git://xenbits.xen.org/ovmf.git;
        rev = "447d264115c476142f884af0be287622cd244423";
        sha256 = "7086f882495a8be1497d881074e8f1005dc283a5e1686aec06c1913c76a6319b";
      }
    ];


  # Sources needed to build the stubdoms and tools
  xenExtfiles = [
      { url = http://xenbits.xensource.com/xen-extfiles/lwip-1.3.0.tar.gz;
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
      { url = http://xenbits.xensource.com/xen-extfiles/tpm_emulator-0.7.4.tar.gz;
        sha256 = "0nd4vs48j0zfzv1g5jymakxbjqf9ss6b2jph3b64356xhc6ylj2f";
      }
      { url = http://xenbits.xensource.com/xen-extfiles/tboot-20090330.tar.gz;
        sha256 = "0rl1b53g019w2c268pyxhjqsj9ls37i4p74bdv1hdi2yvs0r1y81";
      }
      { url = http://xenbits.xensource.com/xen-extfiles/ipxe-git-9a93db3f0947484e30e753bbd61a10b17336e20e.tar.gz;
        sha256 = "0p206zaxlhda60ci33h9gipi5gm46fvvsm6k5c0w7b6cjg0yhb33";
      }
      { url = http://xenbits.xensource.com/xen-extfiles/polarssl-1.1.4-gpl.tgz;
        sha256 = "1dl4fprpwagv9akwqpb62qwqvh24i50znadxwvd2kfnhl02gsa9d";
      }
      { url = http://xenbits.xensource.com/xen-extfiles/gmp-4.3.2.tar.bz2;
        sha256 = "0x8prpqi9amfcmi7r4zrza609ai9529pjaq0h4aw51i867064qck";
      }
    ];

in

stdenv.mkDerivation {
  name = "xen-${version}";

  src = fetchurl {
    url = "http://bits.xensource.com/oss-xen/release/${version}/xen-${version}.tar.gz";
    sha256 = "09gaqydqmy64s5pqnwgjyzhd3wc61xyghpqjfl97kmvm8ly9vd2m";
  };

  dontUseCmakeConfigure = true;

  buildInputs =
    [ which zlib pkgconfig SDL openssl libuuid gettext ncurses
      dev86 iasl pciutils bzip2 xz texinfo perl yajl
      pythonPackages.python pythonPackages.wrapPython
      glib bridge_utils pixman iproute udev bison xlibs.libX11
      flex ocaml ocamlPackages.findlib figlet libaio
      checkpolicy pythonPackages.markdown transfig
      glusterfs cmake
    ];

  pythonPath = [ pythonPackages.curses ];


  preConfigure = ''
    # Fake wget: copy prefetched downloads instead
    mkdir wget
    echo "#!/bin/sh" > wget/wget
    echo "echo ===== Not fetching \$*, copy pre-fetched file instead" >> wget/wget
    echo "cp \$4 \$3" >> wget/wget
    chmod +x wget/wget
    export PATH=$PATH:$PWD/wget
  '';

  makeFlags = "PREFIX=$(out) CONFIG_DIR=/etc XEN_EXTFILES_URL=\\$(XEN_ROOT)/xen_ext_files ";

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

      substituteInPlace tools/ioemu-qemu-xen/xen-hooks.mak \
        --replace /usr/include/pci ${pciutils}/include/pci

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

      # Xen's tools and firmares need various git repositories that it
      # usually checks out at time using git.  We can't have that.
      ${flip concatMapStrings toolsGits (x: let src = fetchgit x; in ''
        cp -r ${src} tools/${src.name}-dir-remote
        chmod +w tools/${src.name}-dir-remote
      '')}
      ${flip concatMapStrings firmwareGits (x: let src = fetchgit x; in ''
        cp -r ${src} tools/firmware/${src.name}-dir-remote
        chmod +w tools/firmware/${src.name}-dir-remote
      '')}

      # Xen's stubdoms and firmwares need various sources that are usually fetched
      # at build time using wget. We can't have that, so we prefetch Xen's ext_files.
      mkdir xen_ext_files
      ${flip concatMapStrings xenExtfiles (x: let src = fetchurl x; in ''
        cp ${src} xen_ext_files/${src.name}
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
    maintainers = with stdenv.lib.maintainers; [ eelco tstrobel ];
  };
}
