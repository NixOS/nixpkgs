config:
{ lib, stdenv, cmake, pkg-config, which

# Xen
, bison, bzip2, checkpolicy, dev86, figlet, flex, gettext, glib
, acpica-tools, libaio, libiconv, libuuid, ncurses, openssl, perl
, xz, yajl, zlib
, python3Packages

# Xen Optional
, ocamlPackages

# Scripts
, coreutils, gawk, gnused, gnugrep, diffutils, multipath-tools
, iproute2, inetutils, iptables, bridge-utils, openvswitch, nbd, drbd
, util-linux, procps, systemd

# Documentation
# python3Packages.markdown
, fig2dev, ghostscript, texinfo, pandoc

, binutils-unwrapped

, ...} @ args:

with lib;

let
  #TODO: fix paths instead
  scriptEnvPath = concatMapStringsSep ":" (x: "${x}/bin") [
    which perl
    coreutils gawk gnused gnugrep diffutils util-linux multipath-tools
    iproute2 inetutils iptables bridge-utils openvswitch nbd drbd
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

  # We don't want to use the wrapped version, because this version of ld is
  # only used for linking the Xen EFI binary, and the build process really
  # needs control over the LDFLAGS used
  efiBinutils = binutils-unwrapped.overrideAttrs (oldAttrs: {
    name = "efi-binutils";
    configureFlags = oldAttrs.configureFlags ++ [
      "--enable-targets=x86_64-pep"
    ];
    doInstallCheck = false; # We get a spurious failure otherwise, due to host/target mis-match
  });
in

stdenv.mkDerivation (rec {
  inherit (config) version;

  name = "xen-${version}";

  dontUseCmakeConfigure = true;

  hardeningDisable = [ "stackprotector" "fortify" "pic" ];

  nativeBuildInputs = [ pkg-config cmake ];
  buildInputs = [
    which

    # Xen
    bison bzip2 checkpolicy dev86 figlet flex gettext glib acpica-tools libaio
    libiconv libuuid ncurses openssl perl python3Packages.python xz yajl zlib

    # oxenstored
    ocamlPackages.findlib ocamlPackages.ocaml systemd

    # Python fixes
    python3Packages.wrapPython

    # Documentation
    python3Packages.markdown fig2dev ghostscript texinfo pandoc

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

  patches = [
  ] ++ (config.patches or []);

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

    substituteInPlace tools/misc/xenpvnetboot \
      --replace /usr/sbin/mount ${util-linux}/bin/mount \
      --replace /usr/sbin/umount ${util-linux}/bin/umount

    substituteInPlace tools/xenmon/xenmon.py \
      --replace /usr/bin/pkill ${procps}/bin/pkill

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

  EFI_LD = "${efiBinutils}/bin/ld";
  EFI_VENDOR = "nixos";

  # TODO: Flask needs more testing before enabling it by default.
  #makeFlags = [ "XSM_ENABLE=y" "FLASK_ENABLE=y" "PREFIX=$(out)" "CONFIG_DIR=/etc" "XEN_EXTFILES_URL=\\$(XEN_ROOT)/xen_ext_files" ];
  makeFlags = [ "PREFIX=$(out) CONFIG_DIR=/etc" "XEN_SCRIPT_DIR=/etc/xen/scripts" ]
           ++ (config.makeFlags or []);

  preBuild = ''
    ${config.preBuild or ""}
  '';

  buildFlags = [ "xen" "tools" ];

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
    homepage = "http://www.xen.org/";
    description = "Xen hypervisor and related components"
                + optionalString (args ? meta && args.meta ? description)
                                 " (${args.meta.description})";
    longDescription = (args.meta.longDescription or "")
                    + "\nIncludes:\n"
                    + withXenfiles (name: x: "* ${name}: ${x.meta.description or "(No description)"}.");
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
    license = lib.licenses.gpl2;
    knownVulnerabilities = [
      # https://www.openwall.com/lists/oss-security/2023/03/21/1
      # Affects 3.2 (at *least*) - 4.17
      "CVE-2022-42332"
      # https://www.openwall.com/lists/oss-security/2023/03/21/2
      # Affects 4.11 - 4.17
      "CVE-2022-42333"
      "CVE-2022-42334"
      # https://www.openwall.com/lists/oss-security/2023/03/21/3
      # Affects 4.15 - 4.17
      "CVE-2022-42331"
    # https://xenbits.xen.org/docs/unstable/support-matrix.html
    ] ++ lib.optionals (lib.versionOlder version "4.15") [
      "This version of Xen has reached its end of life. See https://xenbits.xen.org/docs/unstable/support-matrix.html"
    ];
  } // (config.meta or {});
} // removeAttrs config [ "xenfiles" "buildInputs" "patches" "postPatch" "meta" ])
