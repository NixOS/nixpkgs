{ stdenv, fetchurl, which, zlib, pkgconfig, SDL, openssl
, libuuid, gettext, ncurses, dev86, iasl, pciutils, bzip2
, lvm2, utillinux, procps, texinfo, perl, pythonPackages
, glib, bridge-utils, xorg, pixman, iproute, udev, bison
, flex, cmake, ocaml, ocamlPackages, figlet, libaio, yajl
, checkpolicy, transfig, glusterfs, acl, fetchgit, xz, spice
, spice_protocol, usbredir, alsaLib, quilt
, coreutils, gawk, gnused, gnugrep, diffutils, multipath-tools
, inetutils, iptables, openvswitch, nbd, drbd, xenConfig
, xenserverPatched ? false, ... }:

with stdenv.lib;

let

  libDir = if stdenv.is64bit then "lib64" else "lib";

  # Sources needed to build the tools
  # These sources are already rather old and probably do not change frequently
  xenExtfiles = [
      { url = http://xenbits.xensource.com/xen-extfiles/ipxe-git-9a93db3f0947484e30e753bbd61a10b17336e20e.tar.gz;
        sha256 = "0p206zaxlhda60ci33h9gipi5gm46fvvsm6k5c0w7b6cjg0yhb33";
      }
    ];

  scriptEnvPath = stdenv.lib.concatStrings (stdenv.lib.intersperse ":" (map (x: "${x}/bin")
    [ coreutils gawk gnused gnugrep which perl diffutils utillinux multipath-tools
      iproute inetutils iptables bridge-utils openvswitch nbd drbd ]));
in



stdenv.mkDerivation {
  inherit (xenConfig) name version src;

  dontUseCmakeConfigure = true;

  buildInputs =
    [ which zlib pkgconfig SDL openssl libuuid gettext ncurses
      dev86 iasl pciutils bzip2 xz texinfo perl yajl
      pythonPackages.python pythonPackages.wrapPython
      glib bridge-utils pixman iproute udev bison xorg.libX11
      flex ocaml ocamlPackages.findlib figlet libaio
      checkpolicy pythonPackages.markdown transfig
      glusterfs acl cmake spice spice_protocol usbredir
      alsaLib quilt
    ];

  pythonPath = [ pythonPackages.curses ];

  hardeningDisable = [ "stackprotector" "fortify" "pic" ];

  patches = stdenv.lib.optionals ((xenserverPatched == false) && (builtins.hasAttr "xenPatches" xenConfig)) xenConfig.xenPatches;

  postPatch = ''
      ${stdenv.lib.optionalString ((xenserverPatched == true) && (builtins.hasAttr "xenserverPatches" xenConfig)) xenConfig.xenserverPatches}

      # Xen's tools and firmares need various git repositories that it
      # usually checks out at time using git.  We can't have that.
      ${flip concatMapStrings xenConfig.toolsGits (x: let src = fetchgit x.git; in ''
        cp -r ${src} tools/${src.name}-dir-remote
        chmod -R +w tools/${src.name}-dir-remote
      '' + stdenv.lib.optionalString (builtins.hasAttr "patches" x) ''
        ( cd tools/${src.name}-dir-remote; ${concatStringsSep "; " (map (p: "patch -p1 < ${p}") x.patches)} )
      '')}
      ${flip concatMapStrings xenConfig.firmwareGits (x: let src = fetchgit x.git; in ''
        cp -r ${src} tools/firmware/${src.name}-dir-remote
        chmod -R +w tools/firmware/${src.name}-dir-remote
      '' + stdenv.lib.optionalString (builtins.hasAttr "patches" x) ''
        ( cd tools/firmware/${src.name}-dir-remote; ${concatStringsSep "; " (map (p: "patch -p1 < ${p}") x.patches)} )
      '')}

      # Xen's stubdoms and firmwares need various sources that are usually fetched
      # at build time using wget. We can't have that, so we prefetch Xen's ext_files.
      mkdir xen_ext_files
      ${flip concatMapStrings xenExtfiles (x: let src = fetchurl x; in ''
        cp ${src} xen_ext_files/${src.name}
      '')}
  '';

  preConfigure = ''
    # Fake wget: copy prefetched downloads instead
    mkdir wget
    echo "#!/bin/sh" > wget/wget
    echo "echo ===== Not fetching \$*, copy pre-fetched file instead" >> wget/wget
    echo "cp \$4 \$3" >> wget/wget
    chmod +x wget/wget
    export PATH=$PATH:$PWD/wget
    export EXTRA_QEMUU_CONFIGURE_ARGS="--enable-spice --enable-usb-redir --enable-linux-aio"
  '';

  # https://github.com/NixOS/nixpkgs/issues/13590
  configureFlags = ["--disable-stubdom"];

  postConfigure =
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
        --replace /usr/include/curses.h ${ncurses.dev}/include/curses.h

      substituteInPlace tools/qemu-xen-traditional/xen-hooks.mak \
        --replace /usr/include/pci ${pciutils}/include/pci

      substituteInPlace tools/qemu-xen-traditional-dir-remote/xen-hooks.mak \
        --replace /usr/include/pci ${pciutils}/include/pci

      substituteInPlace tools/hotplug/Linux/xen-backend.rules \
        --replace /etc/xen/scripts $out/etc/xen/scripts

      # blktap is not provided by xen, but by xapi
      sed -i '/blktap/d' tools/hotplug/Linux/xen-backend.rules

      # Work around a bug in our GCC wrapper: `gcc -MF foo -v' doesn't
      # print the GCC version number properly.
      substituteInPlace xen/Makefile \
        --replace '$(CC) $(CFLAGS) -v' '$(CC) -v'

      # Allow the location of the xendomains config file to be
      # overriden at runtime.
      substituteInPlace tools/hotplug/Linux/init.d/xendomains \
        --replace 'XENDOM_CONFIG=/etc/sysconfig/xendomains' "" \
        --replace 'XENDOM_CONFIG=/etc/default/xendomains' "" \
        --replace /etc/xen/scripts/hotplugpath.sh $out/etc/xen/scripts/hotplugpath.sh \
        --replace /bin/ls ls

      substituteInPlace tools/hotplug/Linux/xendomains \
        --replace /bin/ls ls

      # Hack to get `gcc -m32' to work without having 32-bit Glibc headers.
      mkdir -p tools/include/gnu
      touch tools/include/gnu/stubs-32.h
    '';

  # TODO: Flask needs more testing before enabling it by default.
  #makeFlags = "XSM_ENABLE=y FLASK_ENABLE=y PREFIX=$(out) CONFIG_DIR=/etc XEN_EXTFILES_URL=\\$(XEN_ROOT)/xen_ext_files ";
  makeFlags = "PREFIX=$(out) CONFIG_DIR=/etc XEN_EXTFILES_URL=\\$(XEN_ROOT)/xen_ext_files ";

  buildFlags = "xen tools";

  postBuild =
    ''
      make -C docs man-pages

      (cd tools/xen-libhvm-dir-remote; make)
      (cd tools/xen-libhvm-dir-remote/biospt; cc -Wall -g -D_LINUX -Wstrict-prototypes biospt.c -o biospt -I../libhvm -L../libhvm -lxenhvm)
    '';

  installPhase =
    ''
      mkdir -p $out $out/share
      cp -prvd dist/install/nix/store/*/* $out/
      cp -prvd dist/install/boot $out/boot
      cp -prvd dist/install/etc $out
      cp -dR docs/man1 docs/man5 $out/share/man/
      wrapPythonPrograms
      substituteInPlace $out/etc/xen/scripts/hotplugpath.sh --replace SBINDIR=\"$out/sbin\" SBINDIR=\"$out/bin\"

      shopt -s extglob
      for i in $out/etc/xen/scripts/!(*.sh); do
        sed -i "2s@^@export PATH=$out/bin:${scriptEnvPath}\n@" $i
      done

      (cd tools/xen-libhvm-dir-remote; make install)
      cp tools/xen-libhvm-dir-remote/biospt/biospt $out/bin/.
    '';

  meta = {
    homepage = http://www.xen.org/;
    description = "Xen hypervisor and management tools for Dom0";
    platforms = [ "x86_64-linux" ];
    maintainers = with stdenv.lib.maintainers; [ eelco tstrobel ];
  };
}
