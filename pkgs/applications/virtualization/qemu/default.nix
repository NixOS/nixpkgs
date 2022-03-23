{ lib, stdenv, fetchurl, fetchpatch, python3, python3Packages, zlib, pkg-config, glib, buildPackages
, perl, pixman, vde2, alsa-lib, texinfo, flex
, bison, lzo, snappy, libaio, libtasn1, gnutls, nettle, curl, ninja, meson, sigtool
, makeWrapper, runtimeShell, removeReferencesTo
, attr, libcap, libcap_ng, socat
, CoreServices, Cocoa, Hypervisor, rez, setfile
, numaSupport ? stdenv.isLinux && !stdenv.isAarch32, numactl
, seccompSupport ? stdenv.isLinux, libseccomp
, alsaSupport ? lib.hasSuffix "linux" stdenv.hostPlatform.system && !nixosTestRunner
, pulseSupport ? !stdenv.isDarwin && !nixosTestRunner, libpulseaudio
, sdlSupport ? !stdenv.isDarwin && !nixosTestRunner, SDL2, SDL2_image
, jackSupport ? !stdenv.isDarwin && !nixosTestRunner, libjack2
, gtkSupport ? !stdenv.isDarwin && !xenSupport && !nixosTestRunner, gtk3, gettext, vte, wrapGAppsHook
, vncSupport ? !nixosTestRunner, libjpeg, libpng
, smartcardSupport ? !nixosTestRunner, libcacard
, spiceSupport ? !stdenv.isDarwin && !nixosTestRunner, spice, spice-protocol
, ncursesSupport ? !nixosTestRunner, ncurses
, usbredirSupport ? spiceSupport, usbredir
, xenSupport ? false, xen
, cephSupport ? false, ceph
, glusterfsSupport ? false, glusterfs, libuuid
, openGLSupport ? sdlSupport, mesa, libepoxy, libdrm
, virglSupport ? openGLSupport, virglrenderer
, libiscsiSupport ? true, libiscsi
, smbdSupport ? false, samba
, tpmSupport ? true
, uringSupport ? stdenv.isLinux, liburing
, hostCpuOnly ? false
, hostCpuTargets ? (if hostCpuOnly
                    then (lib.optional stdenv.isx86_64 "i386-softmmu"
                          ++ ["${stdenv.hostPlatform.qemuArch}-softmmu"])
                    else null)
, nixosTestRunner ? false
, doCheck ? false
, qemu  # for passthru.tests
}:

stdenv.mkDerivation rec {
  pname = "qemu"
    + lib.optionalString xenSupport "-xen"
    + lib.optionalString hostCpuOnly "-host-cpu-only"
    + lib.optionalString nixosTestRunner "-for-vm-tests";
  version = "6.2.0";

  src = fetchurl {
    url= "https://download.qemu.org/qemu-${version}.tar.xz";
    sha256 = "0iavlsy9hin8k38230j8lfmyipx3965zljls1dp34mmc8n75vqb8";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [ makeWrapper removeReferencesTo pkg-config flex bison meson ninja perl python3 python3Packages.sphinx python3Packages.sphinx_rtd_theme ]
    ++ lib.optionals gtkSupport [ wrapGAppsHook ]
    ++ lib.optionals stdenv.isDarwin [ sigtool ];

  buildInputs = [ zlib glib perl pixman
    vde2 texinfo lzo snappy libtasn1
    gnutls nettle curl
  ]
    ++ lib.optionals ncursesSupport [ ncurses ]
    ++ lib.optionals stdenv.isDarwin [ CoreServices Cocoa Hypervisor rez setfile ]
    ++ lib.optionals seccompSupport [ libseccomp ]
    ++ lib.optionals numaSupport [ numactl ]
    ++ lib.optionals alsaSupport [ alsa-lib ]
    ++ lib.optionals pulseSupport [ libpulseaudio ]
    ++ lib.optionals sdlSupport [ SDL2 SDL2_image ]
    ++ lib.optionals jackSupport [ libjack2 ]
    ++ lib.optionals gtkSupport [ gtk3 gettext vte ]
    ++ lib.optionals vncSupport [ libjpeg libpng ]
    ++ lib.optionals smartcardSupport [ libcacard ]
    ++ lib.optionals spiceSupport [ spice-protocol spice ]
    ++ lib.optionals usbredirSupport [ usbredir ]
    ++ lib.optionals stdenv.isLinux [ libaio libcap_ng libcap attr ]
    ++ lib.optionals xenSupport [ xen ]
    ++ lib.optionals cephSupport [ ceph ]
    ++ lib.optionals glusterfsSupport [ glusterfs libuuid ]
    ++ lib.optionals openGLSupport [ mesa libepoxy libdrm ]
    ++ lib.optionals virglSupport [ virglrenderer ]
    ++ lib.optionals libiscsiSupport [ libiscsi ]
    ++ lib.optionals smbdSupport [ samba ]
    ++ lib.optionals uringSupport [ liburing ];

  dontUseMesonConfigure = true; # meson's configurePhase isn't compatible with qemu build

  outputs = [ "out" "ga" ];
  # On aarch64-linux we would shoot over the Hydra's 2G output limit.
  separateDebugInfo = !(stdenv.isAarch64 && stdenv.isLinux);

  patches = [
    ./fix-qemu-ga.patch
    # Cocoa clipboard support only works on macOS 10.14+
    (fetchpatch {
      url = "https://gitlab.com/qemu-project/qemu/-/commit/7e3e20d89129614f4a7b2451fe321cc6ccca3b76.diff";
      sha256 = "09xz06g57wxbacic617pq9c0qb7nly42gif0raplldn5lw964xl2";
      revert = true;
    })
    # 9p-darwin for 7.0 backported to 6.2.0
    #
    # Can generally be removed when updating derivation to 7.0. Nine of the
    # patches can be drawn directly from QEMU upstream, but the second commit
    # and the eleventh commit had to be modified when rebasing back to 6.2.0.
    (fetchpatch {
      url = "https://gitlab.com/qemu-project/qemu/-/commit/e0bd743bb2dd4985791d4de880446bdbb4e04fed.patch";
      sha256 = "sha256-c6QYL3zig47fJwm6rqkqGp3E1PakVTaihvXDRebbBlQ=";
    })
    ./rename-9p-util.patch
    (fetchpatch {
      url = "https://gitlab.com/qemu-project/qemu/-/commit/f41db099c71151291c269bf48ad006de9cbd9ca6.patch";
      sha256 = "sha256-70/rrhZw+02JJbJ3CoW8B1GbdM4Lwb2WkUdwstYAoIQ=";
    })
    (fetchpatch {
      url = "https://gitlab.com/qemu-project/qemu/-/commit/6b3b279bd670c6a2fa23c9049820c814f0e2c846.patch";
      sha256 = "sha256-7WqklSvLirEuxTXTIMQDQhWpXnwMseJ1RumT+faq/Y8=";
    })
    (fetchpatch {
      url = "https://gitlab.com/qemu-project/qemu/-/commit/67a71e3b71a2834d028031a92e76eb9444e423c6.patch";
      sha256 = "sha256-COFm/SwfJSoSl9YDpL6ceAE8CcE4mGhsGxw1HMuL++o=";
    })
    (fetchpatch {
      url = "https://gitlab.com/qemu-project/qemu/-/commit/38d7fd68b0c8775b5253ab84367419621aa032e6.patch";
      sha256 = "sha256-iwGIzq9FWW6zpbDg/IKrp5OZpK9cgQqTRWWq8WBIHRQ=";
    })
    (fetchpatch {
      url = "https://gitlab.com/qemu-project/qemu/-/commit/57b3910bc3513ab515296692daafd1c546f3c115.patch";
      sha256 = "sha256-ybl9+umZAcQKHYL7NkGJQC0W7bccTagA9KQiFaR2LYA=";
    })
    (fetchpatch {
      url = "https://gitlab.com/qemu-project/qemu/-/commit/b5989326f558faedd2511f29459112cced2ca8f5.patch";
      sha256 = "sha256-s+O9eCgj2Ev+INjL9LY9MJBdISIdZLslI3lue2DICGM=";
    })
    (fetchpatch {
      url = "https://gitlab.com/qemu-project/qemu/-/commit/029ed1bd9defa33a80bb40cdcd003699299af8db.patch";
      sha256 = "sha256-mGqcRWcEibDJdhTRrN7ZWrMuCfUWW8vWiFj7sb2/RYo=";
    })
    (fetchpatch {
      url = "https://gitlab.com/qemu-project/qemu/-/commit/d3671fd972cd185a6923433aa4802f54d8b62112.patch";
      sha256 = "sha256-GUh5o7mbFTm/dm6CqcGdoMlC+YrV8RlcEwu/mxrfTzo=";
    })
    # The next two commits are to make Linux v5.17 work on aarch64-darwin. These are included in QEMU v7.
    (fetchpatch {
      url = "https://gitlab.com/qemu-project/qemu/-/commit/ad99f64f1cfff7c5e7af0e697523d9b7e45423b6.patch";
      sha256 = "sha256-e6WtfQIPEiXhWucd5ab7UIoccbWEAv3bwksn4hR85CY=";
    })
    (fetchpatch {
      url = "https://gitlab.com/qemu-project/qemu/-/commit/7f6c295cdfeaa229c360cac9a36e4e595aa902ae.patch";
      sha256 = "sha256-mORtgfU1CYQFKO5UrXgM9cJyZxeF2bz8iAoq0UlFQeY=";
    })
    ./allow-virtfs-on-darwin.patch
    # QEMU upstream does not demand compatibility to pre-10.13, so 9p-darwin
    # support on nix requires utimensat fallback. The patch adding this fallback
    # set was removed during the process of upstreaming this functionality, and
    # will still be needed in nix until the macOS SDK reaches 10.13+.
    ./provide-fallback-for-utimensat.patch
  ]
    ++ lib.optional nixosTestRunner ./force-uid0-on-9p.patch;

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
  '';

  configureFlags = [
    "--disable-strip" # We'll strip ourselves after separating debug info.
    "--enable-docs"
    "--enable-tools"
    "--enable-guest-agent"
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    # Always use our Meson, not the bundled version, which doesn't
    # have our patches and will be subtly broken because of that.
    "--meson=meson"
    "--cross-prefix=${stdenv.cc.targetPrefix}"
    "--cpu=${stdenv.hostPlatform.uname.processor}"
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
    ++ lib.optional smbdSupport "--smbd=${samba}/bin/smbd"
    ++ lib.optional uringSupport "--enable-linux-io-uring";

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
    remove-references-to -t $out $ga/bin/qemu-ga
  '' + lib.optionalString gtkSupport ''
    # wrap GTK Binaries
    for f in $out/bin/qemu-system-*; do
      wrapGApp $f
    done
  '';
  preBuild = "cd build";

  # tests can still timeout on slower systems
  inherit doCheck;
  checkInputs = [ socat ];
  preCheck = ''
    # time limits are a little meagre for a build machine that's
    # potentially under load.
    substituteInPlace ../tests/unit/meson.build \
      --replace 'timeout: slow_tests' 'timeout: 50 * slow_tests'
    substituteInPlace ../tests/qtest/meson.build \
      --replace 'timeout: slow_qtests' 'timeout: 50 * slow_qtests'
    substituteInPlace ../tests/fp/meson.build \
      --replace 'timeout: 90)' 'timeout: 300)'

    # point tests towards correct binaries
    substituteInPlace ../tests/unit/test-qga.c \
      --replace '/bin/echo' "$(type -P echo)"
    substituteInPlace ../tests/unit/test-io-channel-command.c \
      --replace '/bin/socat' "$(type -P socat)"

    # combined with a long package name, some temp socket paths
    # can end up exceeding max socket name len
    substituteInPlace ../tests/qtest/bios-tables-test.c \
      --replace 'qemu-test_acpi_%s_tcg_%s' '%s_%s'

    # get-fsinfo attempts to access block devices, disallowed by sandbox
    sed -i -e '/\/qga\/get-fsinfo/d' -e '/\/qga\/blacklist/d' \
      ../tests/unit/test-qga.c
  '' + lib.optionalString stdenv.isDarwin ''
    # skip test that stalls on darwin, perhaps due to subtle differences
    # in fifo behaviour
    substituteInPlace ../tests/unit/meson.build \
      --replace "'test-io-channel-command'" "#'test-io-channel-command'"
  '';

  # Add a ‘qemu-kvm’ wrapper for compatibility/convenience.
  postInstall = ''
    ln -s $out/libexec/virtiofsd $out/bin
    ln -s $out/bin/qemu-system-${stdenv.hostPlatform.qemuArch} $out/bin/qemu-kvm
  '';

  passthru = {
    qemu-system-i386 = "bin/qemu-system-i386";
    tests = {
      qemu-tests = qemu.override { doCheck = true; };
    };
  };

  # Builds in ~3h with 2 cores, and ~20m with a big-parallel builder.
  requiredSystemFeatures = [ "big-parallel" ];

  meta = with lib; {
    homepage = "http://www.qemu.org/";
    description = "A generic and open source machine emulator and virtualizer";
    license = licenses.gpl2Plus;
    mainProgram = "qemu-kvm";
    maintainers = with maintainers; [ eelco qyliss ];
    platforms = platforms.unix;
    priority = 10; # Prefer virtiofsd from the virtiofsd package.
  };
}
