{ lib, stdenv, fetchurl, fetchpatch, python3Packages, zlib, pkg-config, glib, buildPackages
, pixman, vde2, alsa-lib, flex, pcre2
, bison, lzo, snappy, libaio, libtasn1, gnutls, nettle, curl, dtc, ninja, meson
, sigtool
, makeWrapper, removeReferencesTo
, attr, libcap, libcap_ng, socat, libslirp
, CoreServices, Cocoa, Hypervisor, rez, setfile, vmnet
, guestAgentSupport ? (with stdenv.hostPlatform; isLinux || isNetBSD || isOpenBSD || isSunOS || isWindows) && !minimal
, numaSupport ? stdenv.isLinux && !stdenv.isAarch32 && !minimal, numactl
, seccompSupport ? stdenv.isLinux && !minimal, libseccomp
, alsaSupport ? lib.hasSuffix "linux" stdenv.hostPlatform.system && !nixosTestRunner && !minimal
, pulseSupport ? !stdenv.isDarwin && !nixosTestRunner && !minimal, libpulseaudio
, pipewireSupport ? !stdenv.isDarwin && !nixosTestRunner && !minimal, pipewire
, sdlSupport ? !stdenv.isDarwin && !nixosTestRunner && !minimal, SDL2, SDL2_image
, jackSupport ? !stdenv.isDarwin && !nixosTestRunner && !minimal, libjack2
, gtkSupport ? !stdenv.isDarwin && !xenSupport && !nixosTestRunner && !minimal, gtk3, gettext, vte, wrapGAppsHook3
, vncSupport ? !nixosTestRunner && !minimal, libjpeg, libpng
, smartcardSupport ? !nixosTestRunner && !minimal, libcacard
, spiceSupport ? true && !nixosTestRunner && !minimal, spice, spice-protocol
, ncursesSupport ? !nixosTestRunner && !minimal, ncurses
, usbredirSupport ? spiceSupport, usbredir
, xenSupport ? false, xen
, cephSupport ? false, ceph
, glusterfsSupport ? false, glusterfs, libuuid
, openGLSupport ? sdlSupport, mesa, libepoxy, libdrm
, rutabagaSupport ? openGLSupport && !minimal && lib.meta.availableOn stdenv.hostPlatform rutabaga_gfx, rutabaga_gfx
, virglSupport ? openGLSupport, virglrenderer
, libiscsiSupport ? !minimal, libiscsi
, smbdSupport ? false, samba
, tpmSupport ? !minimal
, uringSupport ? stdenv.isLinux && !userOnly, liburing
, canokeySupport ? !minimal, canokey-qemu
, capstoneSupport ? !minimal, capstone
, pluginsSupport ? !stdenv.hostPlatform.isStatic
, enableDocs ? !minimal || toolsOnly
, enableTools ? !minimal || toolsOnly
, enableBlobs ? !minimal || toolsOnly
, hostCpuOnly ? false
, hostCpuTargets ? (if toolsOnly
                    then [ ]
                    else if hostCpuOnly
                    then (lib.optional stdenv.isx86_64 "i386-softmmu"
                          ++ ["${stdenv.hostPlatform.qemuArch}-softmmu"])
                    else null)
, nixosTestRunner ? false
, toolsOnly ? false
, userOnly ? false
, minimal ? toolsOnly || userOnly
, gitUpdater
, qemu-utils # for tests attribute
}:

let
  hexagonSupport = hostCpuTargets == null || lib.elem "hexagon" hostCpuTargets;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "qemu"
    + lib.optionalString xenSupport "-xen"
    + lib.optionalString hostCpuOnly "-host-cpu-only"
    + lib.optionalString nixosTestRunner "-for-vm-tests"
    + lib.optionalString toolsOnly "-utils"
    + lib.optionalString userOnly "-user";
  version = "9.0.2";

  src = fetchurl {
    url = "https://download.qemu.org/qemu-${finalAttrs.version}.tar.xz";
    hash = "sha256-qMP1lq7Olto7AMr7dLqvoNFFFer7jtHuP39cLQ6/ArY=";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ]
    ++ lib.optionals hexagonSupport [ pkg-config ];

  nativeBuildInputs = [
    makeWrapper removeReferencesTo
    pkg-config flex bison meson ninja

    # Don't change this to python3 and python3.pkgs.*, breaks cross-compilation
    python3Packages.python
  ]
    ++ lib.optionals gtkSupport [ wrapGAppsHook3 ]
    ++ lib.optionals enableDocs [ python3Packages.sphinx python3Packages.sphinx-rtd-theme ]
    ++ lib.optionals hexagonSupport [ glib ]
    ++ lib.optionals stdenv.isDarwin [ sigtool ]
    ++ lib.optionals (!userOnly) [ dtc ]
    # workaround, remove once this patch lands: https://lore.kernel.org/qemu-devel/20240805104921.4035256-1-hi@alyssa.is/
    ++ lib.optionals (hexagonSupport && stdenv.hostPlatform.isStatic) [ pcre2 ];

  buildInputs = [ zlib glib pixman
    vde2 lzo snappy libtasn1
    gnutls nettle curl libslirp
  ]
    ++ lib.optionals ncursesSupport [ ncurses ]
    ++ lib.optionals stdenv.isDarwin [ CoreServices Cocoa Hypervisor rez setfile vmnet ]
    ++ lib.optionals seccompSupport [ libseccomp ]
    ++ lib.optionals numaSupport [ numactl ]
    ++ lib.optionals alsaSupport [ alsa-lib ]
    ++ lib.optionals pulseSupport [ libpulseaudio ]
    ++ lib.optionals pipewireSupport [ pipewire ]
    ++ lib.optionals sdlSupport [ SDL2 SDL2_image ]
    ++ lib.optionals jackSupport [ libjack2 ]
    ++ lib.optionals gtkSupport [ gtk3 gettext vte ]
    ++ lib.optionals vncSupport [ libjpeg libpng ]
    ++ lib.optionals smartcardSupport [ libcacard ]
    ++ lib.optionals spiceSupport [ spice-protocol spice ]
    ++ lib.optionals usbredirSupport [ usbredir ]
    ++ lib.optionals stdenv.isLinux [ libcap_ng libcap attr ]
    ++ lib.optionals (stdenv.isLinux && !userOnly) [ libaio ]
    ++ lib.optionals xenSupport [ xen ]
    ++ lib.optionals cephSupport [ ceph ]
    ++ lib.optionals glusterfsSupport [ glusterfs libuuid ]
    ++ lib.optionals openGLSupport [ mesa libepoxy libdrm ]
    ++ lib.optionals rutabagaSupport [ rutabaga_gfx ]
    ++ lib.optionals virglSupport [ virglrenderer ]
    ++ lib.optionals libiscsiSupport [ libiscsi ]
    ++ lib.optionals smbdSupport [ samba ]
    ++ lib.optionals uringSupport [ liburing ]
    ++ lib.optionals canokeySupport [ canokey-qemu ]
    ++ lib.optionals capstoneSupport [ capstone ]
    ++ lib.optionals (!userOnly) [ dtc ];

  dontUseMesonConfigure = true; # meson's configurePhase isn't compatible with qemu build
  dontAddStaticConfigureFlags = true;

  outputs = [ "out" ] ++ lib.optional guestAgentSupport "ga";
  # On aarch64-linux we would shoot over the Hydra's 2G output limit.
  separateDebugInfo = !(stdenv.isAarch64 && stdenv.isLinux);

  patches = [
    ./fix-qemu-ga.patch

    # QEMU upstream does not demand compatibility to pre-10.13, so 9p-darwin
    # support on nix requires utimensat fallback. The patch adding this fallback
    # set was removed during the process of upstreaming this functionality, and
    # will still be needed in nix until the macOS SDK reaches 10.13+.
    ./provide-fallback-for-utimensat.patch
    # Cocoa clipboard support only works on macOS 10.14+
    ./revert-ui-cocoa-add-clipboard-support.patch
    # Standard about panel requires AppKit and macOS 10.13+
    ./revert-ui-cocoa-use-the-standard-about-panel.patch
    # Safe area insets require macOS 11+
    ./remove-ui-cocoa-use-safe-area-insets.patch
    # Workaround for upstream issue with nested virtualisation: https://gitlab.com/qemu-project/qemu/-/issues/1008
    (fetchpatch {
      url = "https://gitlab.com/qemu-project/qemu/-/commit/3e4546d5bd38a1e98d4bd2de48631abf0398a3a2.diff";
      sha256 = "sha256-oC+bRjEHixv1QEFO9XAm4HHOwoiT+NkhknKGPydnZ5E=";
      revert = true;
    })
  ]
  ++ lib.optional nixosTestRunner ./force-uid0-on-9p.patch;

  postPatch = ''
    # Otherwise tries to ensure /var/run exists.
    sed -i "/install_emptydir(get_option('localstatedir') \/ 'run')/d" \
        qga/meson.build
  '';

  preConfigure = ''
    unset CPP # intereferes with dependency calculation
    # this script isn't marked as executable b/c it's indirectly used by meson. Needed to patch its shebang
    chmod +x ./scripts/shaderinclude.py
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
    (lib.enableFeature enableDocs "docs")
    (lib.enableFeature enableTools "tools")
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "--cross-prefix=${stdenv.cc.targetPrefix}"
    (lib.enableFeature guestAgentSupport "guest-agent")
  ] ++ lib.optional numaSupport "--enable-numa"
    ++ lib.optional seccompSupport "--enable-seccomp"
    ++ lib.optional smartcardSupport "--enable-smartcard"
    ++ lib.optional spiceSupport "--enable-spice"
    ++ lib.optional usbredirSupport "--enable-usb-redir"
    ++ lib.optional (hostCpuTargets != null) "--target-list=${lib.concatStringsSep "," hostCpuTargets}"
    ++ lib.optionals stdenv.isDarwin [ "--enable-cocoa" "--enable-hvf" ]
    ++ lib.optional (stdenv.isLinux && !userOnly) "--enable-linux-aio"
    ++ lib.optional gtkSupport "--enable-gtk"
    ++ lib.optional xenSupport "--enable-xen"
    ++ lib.optional cephSupport "--enable-rbd"
    ++ lib.optional glusterfsSupport "--enable-glusterfs"
    ++ lib.optional openGLSupport "--enable-opengl"
    ++ lib.optional virglSupport "--enable-virglrenderer"
    ++ lib.optional tpmSupport "--enable-tpm"
    ++ lib.optional libiscsiSupport "--enable-libiscsi"
    ++ lib.optional smbdSupport "--smbd=${samba}/bin/smbd"
    ++ lib.optional uringSupport "--enable-linux-io-uring"
    ++ lib.optional canokeySupport "--enable-canokey"
    ++ lib.optional capstoneSupport "--enable-capstone"
    ++ lib.optional (!pluginsSupport) "--disable-plugins"
    ++ lib.optional (!enableBlobs) "--disable-install-blobs"
    ++ lib.optional userOnly "--disable-system"
    ++ lib.optional stdenv.hostPlatform.isStatic "--static";

  dontWrapGApps = true;

  # QEMU attaches entitlements with codesign and strip removes those,
  # voiding the entitlements and making it non-operational.
  # The alternative is to re-sign with entitlements after stripping:
  # * https://github.com/qemu/qemu/blob/v6.1.0/scripts/entitlement.sh#L25
  dontStrip = stdenv.isDarwin;

  postFixup = ''
    # the .desktop is both invalid and pointless
    rm -f $out/share/applications/qemu.desktop
  '' + lib.optionalString guestAgentSupport ''
    # move qemu-ga (guest agent) to separate output
    mkdir -p $ga/bin
    mv $out/bin/qemu-ga $ga/bin/
    ln -s $ga/bin/qemu-ga $out/bin
    remove-references-to -t $out $ga/bin/qemu-ga
  '' + lib.optionalString gtkSupport ''
    # wrap GTK Binaries
    for f in $out/bin/qemu-system-*; do
      wrapGApp $f
    done
  '' + lib.optionalString stdenv.hostPlatform.isStatic ''
    # HACK: Otherwise the result will have the entire buildInputs closure
    # injected by the pkgsStatic stdenv
    # <https://github.com/NixOS/nixpkgs/issues/83667>
    rm -f $out/nix-support/propagated-build-inputs
  '';
  preBuild = "cd build";

  # tests can still timeout on slower systems
  doCheck = false;
  nativeCheckInputs = [ socat ];
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
      --replace '/bin/bash' "$(type -P bash)" \
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

    # xattrs are not allowed in the sandbox
    substituteInPlace ../tests/qtest/virtio-9p-test.c \
      --replace-fail mapped-xattr mapped-file
  '' + lib.optionalString stdenv.isDarwin ''
    # skip test that stalls on darwin, perhaps due to subtle differences
    # in fifo behaviour
    substituteInPlace ../tests/unit/meson.build \
      --replace "'test-io-channel-command'" "#'test-io-channel-command'"
  '';

  # Add a ‘qemu-kvm’ wrapper for compatibility/convenience.
  postInstall = lib.optionalString (!minimal) ''
    ln -s $out/bin/qemu-system-${stdenv.hostPlatform.qemuArch} $out/bin/qemu-kvm
  '';

  passthru = {
    qemu-system-i386 = "bin/qemu-system-i386";
    tests = lib.optionalAttrs (!toolsOnly) {
      qemu-tests = finalAttrs.finalPackage.overrideAttrs (_: { doCheck = true; });
      qemu-utils-builds = qemu-utils;
    };
    updateScript = gitUpdater {
      # No nicer place to find latest release.
      url = "https://gitlab.com/qemu-project/qemu.git";
      rev-prefix = "v";
      ignoredVersions = "(alpha|beta|rc).*";
    };
  };

  # Builds in ~3h with 2 cores, and ~20m with a big-parallel builder.
  requiredSystemFeatures = [ "big-parallel" ];

  meta = with lib; {
    homepage = "https://www.qemu.org/";
    description = "Generic and open source machine emulator and virtualizer";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ eelco qyliss ];
    platforms = platforms.unix;
  }
  # toolsOnly: Does not have qemu-kvm and there's no main support tool
  # userOnly: There's one qemu-<arch> for every architecture
  // lib.optionalAttrs (!toolsOnly && !userOnly) {
    mainProgram = "qemu-kvm";
  }
  # userOnly: https://qemu.readthedocs.io/en/v9.0.2/user/main.html
  // lib.optionalAttrs userOnly {
    platforms = with platforms; (linux ++ freebsd ++ openbsd ++ netbsd);
    description = "QEMU User space emulator - launch executables compiled for one CPU on another CPU";
  };
})
