{ lib, stdenv, fetchurl, fetchpatch, python, zlib, pkg-config, glib
, perl, pixman, vde2, alsaLib, texinfo, flex
, bison, lzo, snappy, libaio, gnutls, nettle, curl, ninja, meson
, makeWrapper, autoPatchelfHook
, attr, libcap, libcap_ng
, CoreServices, Cocoa, Hypervisor, rez, setfile
, numaSupport ? stdenv.isLinux && !stdenv.isAarch32, numactl
, seccompSupport ? stdenv.isLinux, libseccomp
, alsaSupport ? lib.hasSuffix "linux" stdenv.hostPlatform.system && !nixosTestRunner
, pulseSupport ? !stdenv.isDarwin && !nixosTestRunner, libpulseaudio
, sdlSupport ? !stdenv.isDarwin && !nixosTestRunner, SDL2, SDL2_image
, gtkSupport ? !stdenv.isDarwin && !xenSupport && !nixosTestRunner, gtk3, gettext, vte, wrapGAppsHook
, vncSupport ? !nixosTestRunner, libjpeg, libpng
, smartcardSupport ? !nixosTestRunner, libcacard
, spiceSupport ? !stdenv.isDarwin && !nixosTestRunner, spice, spice-protocol
, ncursesSupport ? !nixosTestRunner, ncurses
, usbredirSupport ? spiceSupport, usbredir
, xenSupport ? false, xen
, cephSupport ? false, ceph
, openGLSupport ? sdlSupport, mesa, epoxy, libdrm
, virglSupport ? openGLSupport, virglrenderer
, libiscsiSupport ? true, libiscsi
, smbdSupport ? false, samba
, tpmSupport ? true
, hostCpuOnly ? false
, hostCpuTargets ? (if hostCpuOnly
                    then (lib.optional stdenv.isx86_64 "i386-softmmu"
                          ++ ["${stdenv.hostPlatform.qemuArch}-softmmu"])
                    else null)
, nixosTestRunner ? false
}:

with lib;
let
  audio = optionalString alsaSupport "alsa,"
    + optionalString pulseSupport "pa,"
    + optionalString sdlSupport "sdl,";

in

stdenv.mkDerivation rec {
  version = "5.2.0";
  pname = "qemu"
    + lib.optionalString xenSupport "-xen"
    + lib.optionalString hostCpuOnly "-host-cpu-only"
    + lib.optionalString nixosTestRunner "-for-vm-tests";

  src = fetchurl {
    url= "https://download.qemu.org/qemu-${version}.tar.xz";
    sha256 = "1g0pvx4qbirpcn9mni704y03n3lvkmw2c0rbcwvydyr8ns4xh66b";
  };

  nativeBuildInputs = [ python python.pkgs.sphinx pkg-config flex bison meson ninja ]
    ++ optionals gtkSupport [ wrapGAppsHook ]
    ++ optionals stdenv.isLinux [ autoPatchelfHook ];
  buildInputs =
    [ zlib glib perl pixman
      vde2 texinfo makeWrapper lzo snappy
      gnutls nettle curl
    ]
    ++ optionals ncursesSupport [ ncurses ]
    ++ optionals stdenv.isDarwin [ CoreServices Cocoa Hypervisor rez setfile ]
    ++ optionals seccompSupport [ libseccomp ]
    ++ optionals numaSupport [ numactl ]
    ++ optionals pulseSupport [ libpulseaudio ]
    ++ optionals sdlSupport [ SDL2 SDL2_image ]
    ++ optionals gtkSupport [ gtk3 gettext vte ]
    ++ optionals vncSupport [ libjpeg libpng ]
    ++ optionals smartcardSupport [ libcacard ]
    ++ optionals spiceSupport [ spice-protocol spice ]
    ++ optionals usbredirSupport [ usbredir ]
    ++ optionals stdenv.isLinux [ alsaLib libaio libcap_ng libcap attr ]
    ++ optionals xenSupport [ xen ]
    ++ optionals cephSupport [ ceph ]
    ++ optionals openGLSupport [ mesa epoxy libdrm ]
    ++ optionals virglSupport [ virglrenderer ]
    ++ optionals libiscsiSupport [ libiscsi ]
    ++ optionals smbdSupport [ samba ];

  dontUseMesonConfigure = true; # meson's configurePhase isn't compatible with qemu build

  outputs = [ "out" "ga" ];

  patches = [
    ./fix-qemu-ga.patch
    ./9p-ignore-noatime.patch
    (fetchpatch {
      name = "CVE-2020-27821.patch";
      url = "https://sources.debian.org/data/main/q/qemu/1:5.2+dfsg-10/debian/patches/memory-clamp-cached-translation-if-points-to-MMIO-region-CVE-2020-27821.patch";
      sha256 = "0sj0kr0g6jalygr5mb9i17fgr491jzaxvk3dvala0268940s01x9";
    })
    (fetchpatch {
      name = "CVE-2021-20221.patch";
      url = "https://sources.debian.org/data/main/q/qemu/1:5.2+dfsg-10/debian/patches/arm_gic-fix-interrupt-ID-in-GICD_SGIR-CVE-2021-20221.patch";
      sha256 = "1iyvcw87hzlc57fg5l87vddqmch8iw2yghk0s125hk5shn1bygjq";
    })
    (fetchpatch {
      name = "CVE-2021-20181.patch";
      url = "https://sources.debian.org/data/main/q/qemu/1:5.2+dfsg-10/debian/patches/9pfs-Fully-restart-unreclaim-loop-CVE-2021-20181.patch";
      sha256 = "149ifiazj6rn4d4mv2c7lcayq744fijsv5abxlb8bhbkj99wd64f";
    })
    (fetchpatch {
      name = "CVE-2020-35517.part-1.patch";
      url = "https://sources.debian.org/data/main/q/qemu/1:5.2+dfsg-10/debian/patches/virtiofsd-extract-lo_do_open-from-lo_open.patch";
      sha256 = "0j4waaz6q54by4a7vd5m8s2n8y0an9hqf0ndycxsy03g4ksm669d";
    })
    (fetchpatch {
      name = "CVE-2020-35517.part-2.patch";
      url = "https://sources.debian.org/data/main/q/qemu/1:5.2+dfsg-10/debian/patches/virtiofsd-optionally-return-inode-pointer-from-lo_do_lookup.patch";
      sha256 = "08bag890r6dx2rhnq58gyvsxvzwqgvn83pjlg95b5ic0z6gyjnsg";
    })
    (fetchpatch {
      name = "CVE-2020-35517.part-3.patch";
      url = "https://sources.debian.org/data/main/q/qemu/1:5.2+dfsg-10/debian/patches/virtiofsd-prevent-opening-of-special-files-CVE-2020-35517.patch";
      sha256 = "0ziy6638zbkn037l29ywirvgymbqq66l5rngg8iwyky67acilv94";
    })
    (fetchpatch {
      name = "CVE-2021-20263.part-1.patch";
      url = "https://sources.debian.org/data/main/q/qemu/1:5.2+dfsg-10/debian/patches/virtiofsd-save-error-code-early-at-the-failure-callsite.patch";
      sha256 = "15rwb15yjpclrqaxkhx76npr8zlfm9mj4jb19czg093is2cn4rys";
    })
    (fetchpatch {
      name = "CVE-2021-20263.part-2.patch";
      url = "https://sources.debian.org/data/main/q/qemu/1:5.2+dfsg-10/debian/patches/virtiofsd-drop-remapped-security.capability-xattr-as-needed-CVE-2021-20263.patch";
      sha256 = "06ylz80ilg30wlskd4dsjx677fp5qr8cranwlakvjhr88b630xw0";
    })
    (fetchpatch {
      name = "CVE-2021-3416.part-1.patch";
      url = "https://sources.debian.org/data/main/q/qemu/1:5.2+dfsg-10/debian/patches/net-qemu_receive_packet-for-loopback-introduce.patch";
      sha256 = "0hcpf00vqpg9rc0wl8cry905w04614843aqifybyv15wbv190gpz";
    })
    (fetchpatch {
      name = "CVE-2021-3416.part-2.patch";
      url = "https://sources.debian.org/data/main/q/qemu/1:5.2+dfsg-10/debian/patches/net-qemu_receive_packet-for-loopback-cadence_gem.patch";
      sha256 = "12mjnrvs6p4g5frzqb08k4h86hphdqlka91fcma2a3m4ap98nrxy";
    })
    (fetchpatch {
      name = "CVE-2021-3416.part-3.patch";
      url = "https://sources.debian.org/data/main/q/qemu/1:5.2+dfsg-10/debian/patches/net-qemu_receive_packet-for-loopback-dp8393x.patch";
      sha256 = "02z6q0578fj55phjlg2larrsx3psch2ixzy470yf57jl3jq1dy6k";
    })
    (fetchpatch {
      name = "CVE-2021-3416.part-4.patch";
      url = "https://sources.debian.org/data/main/q/qemu/1:5.2+dfsg-10/debian/patches/net-qemu_receive_packet-for-loopback-e1000.patch";
      sha256 = "0zzbiz8i9js524mcdi739c7hrsmn82gnafrygi0xrd5sqf1hp08z";
    })
    (fetchpatch {
      name = "CVE-2021-3416.part-5.patch";
      url = "https://sources.debian.org/data/main/q/qemu/1:5.2+dfsg-10/debian/patches/net-qemu_receive_packet-for-loopback-lan9118.patch";
      sha256 = "1f44v5znd9s7l7wgc71nbg8jw1bjqiga4wkz7d7cpnkv3l7b9kjj";
    })
    (fetchpatch {
      name = "CVE-2021-3416.part-6.patch";
      url = "https://sources.debian.org/data/main/q/qemu/1:5.2+dfsg-10/debian/patches/net-qemu_receive_packet-for-loopback-msf2.patch";
      sha256 = "04n1rzn6gfxdalp34903ysdhlvxqkfndnqayjj3iv1k27i5pcidn";
    })
    (fetchpatch {
      name = "CVE-2021-3416.part-7.patch";
      url = "https://sources.debian.org/data/main/q/qemu/1:5.2+dfsg-10/debian/patches/net-qemu_receive_packet-for-loopback-pcnet.patch";
      sha256 = "1p9ls6f8r6hxprj8ha6278fydcxj3av29p1hvszxmabazml2g7l2";
    })
    (fetchpatch {
      name = "CVE-2021-3416.part-8.patch";
      url = "https://sources.debian.org/data/main/q/qemu/1:5.2+dfsg-10/debian/patches/net-qemu_receive_packet-for-loopback-rtl8139.patch";
      sha256 = "0lms1zn49kpwblkp54widjjy7fwyhdh1x832l1jvds79l2nm6i04";
    })
    (fetchpatch {
      name = "CVE-2021-3416.part-9.patch";
      url = "https://sources.debian.org/data/main/q/qemu/1:5.2+dfsg-10/debian/patches/net-qemu_receive_packet-for-loopback-sungem.patch";
      sha256 = "1mkzyrgsp9ml9yqzjxdfqnwjr7n0fd8vxby4yp4ksrskyni8y0p4";
    })
    (fetchpatch {
      name = "CVE-2021-3416.part-10.patch";
      url = "https://sources.debian.org/data/main/q/qemu/1:5.2+dfsg-10/debian/patches/net-qemu_receive_packet-for-loopback-tx_pkt-iov.patch";
      sha256 = "1pwqq8yw06y3p6hah3dgjhsqzk802wbn7zyajla1zwdfpic63jss";
    })
    (fetchpatch {
      name = "CVE-2021-3409.part-1.patch";
      url = "https://sources.debian.org/data/main/q/qemu/1:5.2+dfsg-10/debian/patches/sdhci/dont-transfer-any-data-when-command-time-out.patch";
      sha256 = "0wf1yhb9mqpfgh9rv0hff0v1sw3zl2vsfgjrby4r8jvxdfjrxj8s";
    })
    (fetchpatch {
      name = "CVE-2021-3409.part-2.patch";
      url = "https://sources.debian.org/data/main/q/qemu/1:5.2+dfsg-10/debian/patches/sdhci/dont-write-to-SDHC_SYSAD-register-when-transfer-is-in-progress.patch";
      sha256 = "1dd405dsdc7fbp68yf6f32js1azsv3n595c6nbxh28kfh9lspx4v";
    })
    (fetchpatch {
      name = "CVE-2021-3409.part-3.patch";
      url = "https://sources.debian.org/data/main/q/qemu/1:5.2+dfsg-10/debian/patches/sdhci/correctly-set-the-controller-status-for-ADMA.patch";
      sha256 = "08jk51pfrbn1zfymahgllrzivajh2v2qx0868rv9zmgi0jldbky6";
    })
    (fetchpatch {
      name = "CVE-2021-3409.part-4.patch";
      url = "https://sources.debian.org/data/main/q/qemu/1:5.2+dfsg-10/debian/patches/sdhci/limit-block-size-only-when-SDHC_BLKSIZE-register-is-writable.patch";
      sha256 = "1valfhw3l83br1cny6n4kmrv0f416hl625mggayqfz4prsknyhh7";
    })
    (fetchpatch {
      name = "CVE-2021-3409.part-5.patch";
      url = "https://sources.debian.org/data/main/q/qemu/1:5.2+dfsg-10/debian/patches/sdhci/reset-the-data-pointer-of-s-fifo_buffer-when-a-different-block-size-is-programmed.patch";
      sha256 = "01p5qrr00rh3mlwrp3qq56h7yhqv0w7pw2cw035nxw3mnap03v31";
    })
    (fetchpatch {
      name = "CVE-2021-3392.patch";
      url = "https://sources.debian.org/data/main/q/qemu/1:5.2+dfsg-10/debian/patches/mptsas-remove-unused-MPTSASState.pending-CVE-2021-3392.patch";
      sha256 = "0n7dn2p102c21mf3ncqrnks0wl5kas6yspafbn8jd03ignjgc4hd";
    })
  ] ++ optional nixosTestRunner ./force-uid0-on-9p.patch
    ++ optionals stdenv.hostPlatform.isMusl [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/alpinelinux/aports/2bb133986e8fa90e2e76d53369f03861a87a74ef/main/qemu/xattr_size_max.patch";
      sha256 = "1xfdjs1jlvs99hpf670yianb8c3qz2ars8syzyz8f2c2cp5y4bxb";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/alpinelinux/aports/2bb133986e8fa90e2e76d53369f03861a87a74ef/main/qemu/musl-F_SHLCK-and-F_EXLCK.patch";
      sha256 = "1gm67v41gw6apzgz7jr3zv9z80wvkv0jaxd2w4d16hmipa8bhs0k";
    })
    ./sigrtminmax.patch
    (fetchpatch {
      url = "https://raw.githubusercontent.com/alpinelinux/aports/2bb133986e8fa90e2e76d53369f03861a87a74ef/main/qemu/fix-sigevent-and-sigval_t.patch";
      sha256 = "0wk0rrcqywhrw9hygy6ap0lfg314m9z1wr2hn8338r5gfcw75mav";
    })
  ];

  # Otherwise tries to ensure /var/run exists.
  postPatch = ''
    sed -i "/install_subdir('run', install_dir: get_option('localstatedir'))/d" \
        qga/meson.build
  '';

  preConfigure = ''
    unset CPP # intereferes with dependency calculation
    # this script isn't marked as executable b/c it's indirectly used by meson. Needed to patch its shebang
    chmod +x ./scripts/shaderinclude.pl
    patchShebangs .
    # avoid conflicts with libc++ include for <version>
    mv VERSION QEMU_VERSION
    substituteInPlace meson.build \
      --replace "'VERSION'" "'QEMU_VERSION'"
  '' + optionalString stdenv.hostPlatform.isMusl ''
    NIX_CFLAGS_COMPILE+=" -D_LINUX_SYSINFO_H"
  '';

  configureFlags =
    [ "--audio-drv-list=${audio}"
      "--enable-docs"
      "--enable-tools"
      "--enable-guest-agent"
      "--localstatedir=/var"
      "--sysconfdir=/etc"
    ]
    ++ optional numaSupport "--enable-numa"
    ++ optional seccompSupport "--enable-seccomp"
    ++ optional smartcardSupport "--enable-smartcard"
    ++ optional spiceSupport "--enable-spice"
    ++ optional usbredirSupport "--enable-usb-redir"
    ++ optional (hostCpuTargets != null) "--target-list=${lib.concatStringsSep "," hostCpuTargets}"
    ++ optional stdenv.isDarwin "--enable-cocoa"
    ++ optional stdenv.isDarwin "--enable-hvf"
    ++ optional stdenv.isLinux "--enable-linux-aio"
    ++ optional gtkSupport "--enable-gtk"
    ++ optional xenSupport "--enable-xen"
    ++ optional cephSupport "--enable-rbd"
    ++ optional openGLSupport "--enable-opengl"
    ++ optional virglSupport "--enable-virglrenderer"
    ++ optional tpmSupport "--enable-tpm"
    ++ optional libiscsiSupport "--enable-libiscsi"
    ++ optional smbdSupport "--smbd=${samba}/bin/smbd";

  doCheck = false; # tries to access /dev
  dontWrapGApps = true;

  postFixup = ''
    # the .desktop is both invalid and pointless
    rm -f $out/share/applications/qemu.desktop

    # copy qemu-ga (guest agent) to separate output
    mkdir -p $ga/bin
    cp $out/bin/qemu-ga $ga/bin/
  '' + optionalString gtkSupport ''
    # wrap GTK Binaries
    for f in $out/bin/qemu-system-*; do
      wrapGApp $f
    done
  '';
  preBuild = "cd build";

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

  # Builds in ~3h with 2 cores, and ~20m with a big-parallel builder.
  requiredSystemFeatures = [ "big-parallel" ];

  meta = with lib; {
    homepage = "http://www.qemu.org/";
    description = "A generic and open source machine emulator and virtualizer";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ eelco ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
