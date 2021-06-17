{ stdenv, fetchurl, python, zlib, pkgconfig, glib
, ncurses, perl, pixman, vde2, alsaLib, texinfo, flex
, bison, lzo, snappy, libaio, gnutls, nettle, curl, llvmPackages_6
, makeWrapper
, attr, libcap, libcap_ng
, numaSupport ? stdenv.isLinux && !stdenv.isAarch32, numactl
, seccompSupport ? false, libseccomp
, pulseSupport ? true, libpulseaudio
, sdlSupport ? true, SDL
, gtkSupport ? true, gtk3, gettext, vte
, vncSupport ? true, libjpeg, libpng
, spiceSupport ? true, spice, spice-protocol
, usbredirSupport ? spiceSupport, usbredir
, cephSupport ? false, ceph
, openGLSupport ? sdlSupport, mesa, epoxy, libdrm
, virglSupport ? openGLSupport, virglrenderer
, smbdSupport ? false, samba
, hostCpuOnly ? false
, hostCpuTargets ? (if hostCpuOnly
                    then (stdenv.lib.optional stdenv.isx86_64 "i386-softmmu"
                          ++ ["${stdenv.hostPlatform.qemuArch}-softmmu"])
                    else null)
}:

with stdenv.lib;

let
  supportedTargets = crossLists (a: b: "${a}-${b}") [
    [ "i386" "x86_64" "aarch64" "arm" ]
    ([ "softmmu" ] ++ optional stdenv.isLinux "linux-user")
  ];
  # leaving the target list unspecified causes broken targets to be built too
  hostCpuTargets_ = if hostCpuTargets != null then hostCpuTargets else supportedTargets;
  unsupportedTargets = subtractLists supportedTargets hostCpuTargets_;
in
  assert unsupportedTargets == [];

let
  audio = optionalString (hasSuffix "linux" stdenv.hostPlatform.system) "alsa,"
    + optionalString pulseSupport "pa,"
    + optionalString sdlSupport "sdl,";

  version = "2.5.2";
  src = fetchurl {
    name = "hqemu-${version}.tar.gz";
    url = "http://csl.iis.sinica.edu.tw/hqemu/download.php?v=${version}";
    sha256 = "1h92c9m1458drvkfpbgxxyvvpk7x99l021ls61j73cldhxnjmgpg";
  };
  llvmPatch = stdenv.mkDerivation {
    inherit src;
    name = "llvm-hqemu.patch";
    installPhase = "cp patch/llvm/llvm-6.0.patch $out";
    phases = ["unpackPhase" "installPhase"];
  };
  llvmTools = llvmPackages_6.tools.extend (self: super: {
    llvm = super.llvm.overrideAttrs (super_: { patches = super_.patches ++ [ llvmPatch ]; });
  });
in

stdenv.mkDerivation rec {
  inherit src version;
  pname = "hqemu";

  nativeBuildInputs = [ python python.pkgs.sphinx pkgconfig flex bison ];
  buildInputs =
    [ zlib glib ncurses perl pixman
      vde2 texinfo makeWrapper lzo snappy
      gnutls nettle curl llvmTools.llvm llvmTools.clang
    ]
    ++ optionals seccompSupport [ libseccomp ]
    ++ optionals numaSupport [ numactl ]
    ++ optionals pulseSupport [ libpulseaudio ]
    ++ optionals sdlSupport [ SDL ]
    ++ optionals gtkSupport [ gtk3 gettext vte ]
    ++ optionals vncSupport [ libjpeg libpng ]
    ++ optionals spiceSupport [ spice-protocol spice ]
    ++ optionals usbredirSupport [ usbredir ]
    ++ optionals stdenv.isLinux [ alsaLib libaio libcap_ng libcap attr ]
    ++ optionals cephSupport [ ceph ]
    ++ optionals openGLSupport [ mesa epoxy libdrm ]
    ++ optionals virglSupport [ virglrenderer ]
    ++ optionals smbdSupport [ samba ];

  enableParallelBuilding = true;

  outputs = [ "out" "ga" ];

  patches = [
    ./no-etc-install.patch
    ./fix-qemu-ga.patch
    ./9p-ignore-noatime.patch
  ];

  # avoid an apparent collision in registered command-line parameters
  postPatch = ''
    substituteInPlace llvm/llvm.cpp --replace '"threads"' '"hthreads"'
  '';

  hardeningDisable = [ "stackprotector" ];

  preConfigure = ''
    unset CPP # intereferes with dependency calculation
  '' + optionalString stdenv.hostPlatform.isMusl ''
    NIX_CFLAGS_COMPILE+=" -D_LINUX_SYSINFO_H"
  '';

  configureFlags =
    [ "--audio-drv-list=${audio}"
      "--sysconfdir=/etc"
      "--localstatedir=/var"
      "--enable-docs"
      "--enable-llvm"
    ]
    ++ optional numaSupport "--enable-numa"
    ++ optional seccompSupport "--enable-seccomp"
    ++ optional spiceSupport "--enable-spice"
    ++ optional usbredirSupport "--enable-usb-redir"
    ++ optional (hostCpuTargets_ != null) "--target-list=${stdenv.lib.concatStringsSep "," hostCpuTargets_}"
    ++ optional stdenv.isLinux "--enable-linux-aio"
    ++ optional gtkSupport "--enable-gtk"
    ++ optional cephSupport "--enable-rbd"
    ++ optional openGLSupport "--enable-opengl"
    ++ optional virglSupport "--enable-virglrenderer"
    ++ optional smbdSupport "--smbd=${samba}/bin/smbd";

  doCheck = false; # tries to access /dev

  postFixup =
    ''
      # copy qemu-ga (guest agent) to separate output
      mkdir -p $ga/bin
      cp $out/bin/qemu-ga $ga/bin/
    '';

  # Add a ‘qemu-kvm’ wrapper for compatibility/convenience.
  postInstall = ''
    if [ -x $out/bin/qemu-system-${stdenv.hostPlatform.qemuArch} ]; then
      makeWrapper $out/bin/qemu-system-${stdenv.hostPlatform.qemuArch} \
                  $out/bin/qemu-kvm \
                  --add-flags "\$([ -e /dev/kvm ] && echo -enable-kvm)"
    fi
  '';

  passthru = {
    qemu-system-i386 = "bin/qemu-system-i386";
  };

  meta = with stdenv.lib; {
    homepage = http://csl.iis.sinica.edu.tw/hqemu/;
    description = "QEMU fork with LLVM optimizations for binary translation hot-spots";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ris ];
    platforms = platforms.linux;
    knownVulnerabilities = [''
      Being based on QEMU 2.5.0, this is presumably vulnerable to all QEMU weaknesses
      discovered after that.
    ''];
  };
}
