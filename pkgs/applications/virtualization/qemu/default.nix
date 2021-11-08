{ lib, stdenv, fetchurl, fetchpatch, python, zlib, pkg-config, glib
, perl, pixman, vde2, alsa-lib, texinfo, flex
, bison, lzo, snappy, libaio, libtasn1, gnutls, nettle, curl, ninja, meson, sigtool
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
, glusterfsSupport ? false, glusterfs, libuuid
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

let
  audio = lib.optionalString alsaSupport "alsa,"
    + lib.optionalString pulseSupport "pa,"
    + lib.optionalString sdlSupport "sdl,";

in

stdenv.mkDerivation rec {
  pname = "qemu"
    + lib.optionalString xenSupport "-xen"
    + lib.optionalString hostCpuOnly "-host-cpu-only"
    + lib.optionalString nixosTestRunner "-for-vm-tests";
  version = "6.1.0";

  src = fetchurl {
    url= "https://download.qemu.org/qemu-${version}.tar.xz";
    sha256 = "15iw7982g6vc4jy1l9kk1z9sl5bm1bdbwr74y7nvwjs1nffhig7f";
  };

  nativeBuildInputs = [ makeWrapper python python.pkgs.sphinx python.pkgs.sphinx_rtd_theme pkg-config flex bison meson ninja ]
    ++ lib.optionals gtkSupport [ wrapGAppsHook ]
    ++ lib.optionals stdenv.isLinux [ autoPatchelfHook ]
    ++ lib.optionals stdenv.isDarwin [ sigtool ];

  buildInputs = [ zlib glib perl pixman
    vde2 texinfo lzo snappy libtasn1
    gnutls nettle curl
  ]
    ++ lib.optionals ncursesSupport [ ncurses ]
    ++ lib.optionals stdenv.isDarwin [ CoreServices Cocoa Hypervisor rez setfile ]
    ++ lib.optionals seccompSupport [ libseccomp ]
    ++ lib.optionals numaSupport [ numactl ]
    ++ lib.optionals pulseSupport [ libpulseaudio ]
    ++ lib.optionals sdlSupport [ SDL2 SDL2_image ]
    ++ lib.optionals gtkSupport [ gtk3 gettext vte ]
    ++ lib.optionals vncSupport [ libjpeg libpng ]
    ++ lib.optionals smartcardSupport [ libcacard ]
    ++ lib.optionals spiceSupport [ spice-protocol spice ]
    ++ lib.optionals usbredirSupport [ usbredir ]
    ++ lib.optionals stdenv.isLinux [ alsa-lib libaio libcap_ng libcap attr ]
    ++ lib.optionals xenSupport [ xen ]
    ++ lib.optionals cephSupport [ ceph ]
    ++ lib.optionals glusterfsSupport [ glusterfs libuuid ]
    ++ lib.optionals openGLSupport [ mesa epoxy libdrm ]
    ++ lib.optionals virglSupport [ virglrenderer ]
    ++ lib.optionals libiscsiSupport [ libiscsi ]
    ++ lib.optionals smbdSupport [ samba ];

  dontUseMesonConfigure = true; # meson's configurePhase isn't compatible with qemu build

  outputs = [ "out" "ga" ];

  patches = [
    ./fix-qemu-ga.patch
    ./9p-ignore-noatime.patch
    # Cocoa clipboard support only works on macOS 10.14+
    (fetchpatch {
      url = "https://gitlab.com/qemu-project/qemu/-/commit/7e3e20d89129614f4a7b2451fe321cc6ccca3b76.diff";
      sha256 = "09xz06g57wxbacic617pq9c0qb7nly42gif0raplldn5lw964xl2";
      revert = true;
    })
    (fetchpatch {
      name = "CVE-2021-3713.patch"; # remove with next release
      url = "https://gitlab.com/qemu-project/qemu/-/commit/13b250b12ad3c59114a6a17d59caf073ce45b33a.patch";
      sha256 = "0lkzfc7gdlvj4rz9wk07fskidaqysmx8911g914ds1jnczgk71mf";
    })
    # Fixes a crash that frequently happens in some setups that share /nix/store over 9p like nixos tests
    # on some systems. Remove with next release.
    (fetchpatch {
      name = "fix-crash-in-v9fs_walk.patch";
      url = "https://gitlab.com/qemu-project/qemu/-/commit/f83df00900816476cca41bb536e4d532b297d76e.patch";
      sha256 = "sha256-LYGbBLS5YVgq8Bf7NVk7HBFxXq34NmZRPCEG79JPwk8=";
    })
    # Fixes an io error on discard/unmap operation for aio/file backend. Remove with next release.
    (fetchpatch {
      name = "fix-aio-discard-return-value.patch";
      url = "https://gitlab.com/qemu-project/qemu/-/commit/13a028336f2c05e7ff47dfdaf30dfac7f4883e80.patch";
      sha256 = "sha256-23xVixVl+JDBNdhe5j5WY8CB4MsnUo+sjrkAkG+JS6M=";
    })
  ] ++ lib.optional nixosTestRunner ./force-uid0-on-9p.patch
    ++ lib.optionals stdenv.hostPlatform.isMusl [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/alpinelinux/aports/2bb133986e8fa90e2e76d53369f03861a87a74ef/main/qemu/musl-F_SHLCK-and-F_EXLCK.patch";
      sha256 = "1gm67v41gw6apzgz7jr3zv9z80wvkv0jaxd2w4d16hmipa8bhs0k";
    })
    ./sigrtminmax.patch
    (fetchpatch {
      url = "https://raw.githubusercontent.com/alpinelinux/aports/2bb133986e8fa90e2e76d53369f03861a87a74ef/main/qemu/fix-sigevent-and-sigval_t.patch";
      sha256 = "0wk0rrcqywhrw9hygy6ap0lfg314m9z1wr2hn8338r5gfcw75mav";
    })
  ] ++ lib.optionals stdenv.isDarwin [
    # The Hypervisor.framework support patch converted something that can be applied:
    # * https://patchwork.kernel.org/project/qemu-devel/list/?series=548227
    # The base revision is whatever commit there is before the series starts:
    # * https://github.com/patchew-project/qemu/commits/patchew/20210916155404.86958-1-agraf%40csgraf.de
    # The target revision is what patchew has as the series tag from patchwork:
    # * https://github.com/patchew-project/qemu/releases/tag/patchew%2F20210916155404.86958-1-agraf%40csgraf.de
    (fetchpatch {
      url = "https://github.com/patchew-project/qemu/compare/7adb961995a3744f51396502b33ad04a56a317c3..d2603c06d9c4a28e714b9b70fe5a9d0c7b0f934d.diff";
      sha256 = "sha256-nSi5pFf9+EefUmyJzSEKeuxOt39ztgkXQyUB8fTHlcY=";
    })
  ];

  postPatch = ''
    # Otherwise tries to ensure /var/run exists.
    sed -i "/install_subdir('run', install_dir: get_option('localstatedir'))/d" \
        qga/meson.build

    # glibc 2.33 compat fix: if `has_statx = true` is set, `tools/virtiofsd/passthrough_ll.c` will
    # rely on `stx_mnt_id`[1] which is not part of glibc's `statx`-struct definition.
    #
    # `has_statx` will be set to `true` if a simple C program which uses a few `statx`
    # consts & struct fields successfully compiles. It seems as this only builds on glibc-2.33
    # since most likely[2] and because of that, the problematic code-path will be used.
    #
    # [1] https://github.com/torvalds/linux/commit/fa2fcf4f1df1559a0a4ee0f46915b496cc2ebf60#diff-64bab5a0a3fcb55e1a6ad77b1dfab89d2c9c71a770a07ecf44e6b82aae76a03a
    # [2] https://sourceware.org/git/?p=glibc.git;a=blobdiff;f=io/bits/statx-generic.h;h=c34697e3c1fd79cddd60db294302e461ed8db6e2;hp=7a09e94be2abb92d2df612090c132e686a24d764;hb=88a2cf6c4bab6e94a65e9c0db8813709372e9180;hpb=c4e4b2e149705559d28b16a9b47ba2f6142d6a6c
    substituteInPlace meson.build \
      --replace 'has_statx = cc.links(statx_test)' 'has_statx = false'
  '';

  preConfigure = ''
    unset CPP # intereferes with dependency calculation
    # this script isn't marked as executable b/c it's indirectly used by meson. Needed to patch its shebang
    chmod +x ./scripts/shaderinclude.pl
    patchShebangs .
    # avoid conflicts with libc++ include for <version>
    mv VERSION QEMU_VERSION
    substituteInPlace configure \
      --replace '$source_path/VERSION' '$source_path/QEMU_VERSION'
    substituteInPlace meson.build \
      --replace "'VERSION'" "'QEMU_VERSION'"
  '' + lib.optionalString stdenv.hostPlatform.isMusl ''
    NIX_CFLAGS_COMPILE+=" -D_LINUX_SYSINFO_H"
  '';

  configureFlags = [
    "--audio-drv-list=${audio}"
    "--enable-docs"
    "--enable-tools"
    "--enable-guest-agent"
    "--localstatedir=/var"
    "--sysconfdir=/etc"
  ] ++ lib.optional numaSupport "--enable-numa"
    ++ lib.optional seccompSupport "--enable-seccomp"
    ++ lib.optional smartcardSupport "--enable-smartcard"
    ++ lib.optional spiceSupport "--enable-spice"
    ++ lib.optional usbredirSupport "--enable-usb-redir"
    ++ lib.optional (hostCpuTargets != null) "--target-list=${lib.concatStringsSep "," hostCpuTargets}"
    ++ lib.optional stdenv.isDarwin "--enable-cocoa"
    ++ lib.optional stdenv.isDarwin "--enable-hvf"
    ++ lib.optional stdenv.isLinux "--enable-linux-aio"
    ++ lib.optional gtkSupport "--enable-gtk"
    ++ lib.optional xenSupport "--enable-xen"
    ++ lib.optional cephSupport "--enable-rbd"
    ++ lib.optional glusterfsSupport "--enable-glusterfs"
    ++ lib.optional openGLSupport "--enable-opengl"
    ++ lib.optional virglSupport "--enable-virglrenderer"
    ++ lib.optional tpmSupport "--enable-tpm"
    ++ lib.optional libiscsiSupport "--enable-libiscsi"
    ++ lib.optional smbdSupport "--smbd=${samba}/bin/smbd";

  doCheck = false; # tries to access /dev
  dontWrapGApps = true;

  # QEMU attaches entitlements with codesign and strip removes those,
  # voiding the entitlements and making it non-operational.
  # The alternative is to re-sign with entitlements after stripping:
  # * https://github.com/qemu/qemu/blob/v6.1.0/scripts/entitlement.sh#L25
  dontStrip = stdenv.isDarwin;

  postFixup = ''
    # the .desktop is both invalid and pointless
    rm -f $out/share/applications/qemu.desktop

    # copy qemu-ga (guest agent) to separate output
    mkdir -p $ga/bin
    cp $out/bin/qemu-ga $ga/bin/
  '' + lib.optionalString gtkSupport ''
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
    maintainers = with maintainers; [ eelco qyliss ];
    platforms = platforms.unix;
  };
}
