config:
{ stdenv, cmake, pkgconfig, which

# Xen
, bison, bzip2, checkpolicy, dev86, figlet, flex, gettext, glib
, iasl, libaio, libiconv, libuuid, ncurses, openssl, perl
, python2Packages
# python2Packages.python
, xz, yajl, zlib

# Xen Optional
, ocamlPackages

# Scripts
, coreutils, gawk, gnused, gnugrep, diffutils, multipath-tools
, iproute, inetutils, iptables, bridge-utils, openvswitch, nbd, drbd
, lvm2, utillinux, procps, systemd

# Documentation
# python2Packages.markdown
, transfig, ghostscript, texinfo, pandoc

, ...} @ args:

with stdenv.lib;

let
  #TODO: fix paths instead
  scriptEnvPath = concatMapStringsSep ":" (x: "${x}/bin") [
    which perl
    coreutils gawk gnused gnugrep diffutils utillinux multipath-tools
    iproute inetutils iptables bridge-utils openvswitch nbd drbd
  ];

  withXenfiles = f: concatStringsSep "\n" (mapAttrsToList f config.xenfiles);

  withTools = a: f: withXenfiles (name: x: optionalString (hasAttr a x) ''
    echo "processing ${name}"
    __do() {
      cd "tools/${name}"
      ${f name x}
    }
    ( __do )
  '');
in

stdenv.mkDerivation (rec {
  inherit (config) version;

  name = "xen-${version}";

  dontUseCmakeConfigure = true;

  hardeningDisable = [ "stackprotector" "fortify" "pic" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    cmake which

    # Xen
    bison bzip2 checkpolicy dev86 figlet flex gettext glib iasl libaio
    libiconv libuuid ncurses openssl perl python2Packages.python xz yajl zlib

    # oxenstored
    ocamlPackages.findlib ocamlPackages.ocaml systemd

    # Python fixes
    python2Packages.wrapPython

    # Documentation
    python2Packages.markdown transfig ghostscript texinfo pandoc

    # Others
  ] ++ (concatMap (x: x.buildInputs or []) (attrValues config.xenfiles))
    ++ (config.buildInputs or []);

  prePatch = ''
    ### Generic fixes

    # Xen's stubdoms, tools and firmwares need various sources that
    # are usually fetched at build time using wget and git. We can't
    # have that, so we prefetch them in nix-expression and setup
    # fake wget and git for debugging purposes.

    mkdir fake-bin

    # Fake git: just print what it wants and die
    cat > fake-bin/wget << EOF
    #!${stdenv.shell} -e
    echo ===== FAKE WGET: Not fetching \$*
    [ -e \$3 ]
    EOF

    # Fake git: just print what it wants and die
    cat > fake-bin/git << EOF
    #!${stdenv.shell}
    echo ===== FAKE GIT: Not cloning \$*
    [ -e \$3 ]
    EOF

    chmod +x fake-bin/*
    export PATH=$PATH:$PWD/fake-bin

    # Remove in-tree qemu stuff in case we build from a tar-ball
    rm -rf tools/qemu-xen tools/qemu-xen-traditional

    # Fix shebangs, mainly for build-scipts
    # We want to do this before getting prefetched stuff to speed things up
    # (prefetched stuff has lots of files)
    find . -type f | xargs sed -i 's@/usr/bin/\(python\|perl\)@/usr/bin/env \1@g'
    find . -type f -not -path "./tools/hotplug/Linux/xendomains.in" \
      | xargs sed -i 's@/bin/bash@${stdenv.shell}@g'

    # Get prefetched stuff
    ${withXenfiles (name: x: ''
      echo "${x.src} -> tools/${name}"
      cp -r ${x.src} tools/${name}
      chmod -R +w tools/${name}
    '')}
  '';

  patches = [ ./0000-fix-ipxe-src.patch
              ./0000-fix-install-python.patch
              ./acpica-utils-20180427.patch]
         ++ (config.patches or []);

  postPatch = ''
    ### Hacks

    # Work around a bug in our GCC wrapper: `gcc -MF foo -v' doesn't
    # print the GCC version number properly.
    substituteInPlace xen/Makefile \
      --replace '$(CC) $(CFLAGS) -v' '$(CC) -v'

    # Hack to get `gcc -m32' to work without having 32-bit Glibc headers.
    mkdir -p tools/include/gnu
    touch tools/include/gnu/stubs-32.h

    ### Fixing everything else

    substituteInPlace tools/libfsimage/common/fsimage_plugin.c \
      --replace /usr $out

    substituteInPlace tools/blktap2/lvm/lvm-util.c \
      --replace /usr/sbin/vgs ${lvm2}/bin/vgs \
      --replace /usr/sbin/lvs ${lvm2}/bin/lvs

    substituteInPlace tools/misc/xenpvnetboot \
      --replace /usr/sbin/mount ${utillinux}/bin/mount \
      --replace /usr/sbin/umount ${utillinux}/bin/umount

    substituteInPlace tools/xenmon/xenmon.py \
      --replace /usr/bin/pkill ${procps}/bin/pkill

    substituteInPlace tools/xenstat/Makefile \
      --replace /usr/include/curses.h ${ncurses.dev}/include/curses.h

    ${optionalString (builtins.compareVersions config.version "4.8" >= 0) ''
      substituteInPlace tools/hotplug/Linux/launch-xenstore.in \
        --replace /bin/mkdir mkdir
    ''}

    ${optionalString (builtins.compareVersions config.version "4.6" < 0) ''
      # TODO: use this as a template and support our own if-up scripts instead?
      substituteInPlace tools/hotplug/Linux/xen-backend.rules.in \
        --replace "@XEN_SCRIPT_DIR@" $out/etc/xen/scripts

      # blktap is not provided by xen, but by xapi
      sed -i '/blktap/d' tools/hotplug/Linux/xen-backend.rules.in
    ''}

    ${withTools "patches" (name: x: ''
      ${concatMapStringsSep "\n" (p: ''
        echo "# Patching with ${p}"
        patch -p1 < ${p}
      '') x.patches}
    '')}

    ${withTools "postPatch" (name: x: x.postPatch)}

    ${config.postPatch or ""}
  '';

  postConfigure = ''
    substituteInPlace tools/hotplug/Linux/xendomains \
      --replace /bin/ls ls
  '';

  # TODO: Flask needs more testing before enabling it by default.
  #makeFlags = "XSM_ENABLE=y FLASK_ENABLE=y PREFIX=$(out) CONFIG_DIR=/etc XEN_EXTFILES_URL=\\$(XEN_ROOT)/xen_ext_files ";
  makeFlags = [ "PREFIX=$(out) CONFIG_DIR=/etc" "XEN_SCRIPT_DIR=/etc/xen/scripts" ]
           ++ (config.makeFlags or []);

  buildFlags = "xen tools";

  postBuild = ''
    make -C docs man-pages

    ${withTools "buildPhase" (name: x: x.buildPhase)}
  '';

  installPhase = ''
    mkdir -p $out $out/share $out/share/man
    cp -prvd dist/install/nix/store/*/* $out/
    cp -prvd dist/install/boot $out/boot
    cp -prvd dist/install/etc $out
    cp -dR docs/man1 docs/man5 $out/share/man/

    ${withTools "installPhase" (name: x: x.installPhase)}

    # Hack
    substituteInPlace $out/etc/xen/scripts/hotplugpath.sh \
      --replace SBINDIR=\"$out/sbin\" SBINDIR=\"$out/bin\"

    wrapPythonPrograms
    # We also need to wrap pygrub, which lies in lib
    wrapPythonProgramsIn "$out/lib" "$out $pythonPath"

    shopt -s extglob
    for i in $out/etc/xen/scripts/!(*.sh); do
      sed -i "2s@^@export PATH=$out/bin:${scriptEnvPath}\n@" $i
    done
  '';

  enableParallelBuilding = true;

  # TODO(@oxij): Stop referencing args here
  meta = {
    homepage = http://www.xen.org/;
    description = "Xen hypervisor and related components"
                + optionalString (args ? meta && args.meta ? description)
                                 " (${args.meta.description})";
    longDescription = (args.meta.longDescription or "")
                    + "\nIncludes:\n"
                    + withXenfiles (name: x: ''* ${name}: ${x.meta.description or "(No description)"}.'');
    platforms = [ "x86_64-linux" ];
    maintainers = with stdenv.lib.maintainers; [ eelco tstrobel oxij ];
    license = stdenv.lib.licenses.gpl2;
  } // (config.meta or {});
} // removeAttrs config [ "xenfiles" "buildInputs" "patches" "postPatch" "meta" ])
