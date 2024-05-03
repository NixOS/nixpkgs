{ lib, stdenv, fetchurl, fetchpatch, python3Packages, zlib, pkg-config, glib, buildPackages
, pixman, vde2, alsa-lib, texinfo, flex
, bison, lzo, snappy, libaio, libtasn1, gnutls, nettle, curl, ninja, meson, sigtool
, makeWrapper, removeReferencesTo
, attr, libcap, libcap_ng, socat, libslirp
, CoreServices, Cocoa, Hypervisor, rez, setfile, vmnet
, guestAgentSupport ? (with stdenv.hostPlatform; isLinux || isNetBSD || isOpenBSD || isSunOS || isWindows) && !toolsOnly
, numaSupport ? stdenv.isLinux && !stdenv.isAarch32 && !toolsOnly, numactl
, seccompSupport ? stdenv.isLinux && !toolsOnly, libseccomp
, alsaSupport ? lib.hasSuffix "linux" stdenv.hostPlatform.system && !nixosTestRunner && !toolsOnly
, pulseSupport ? !stdenv.isDarwin && !nixosTestRunner && !toolsOnly, libpulseaudio
, pipewireSupport ? !stdenv.isDarwin && !nixosTestRunner && !toolsOnly, pipewire
, sdlSupport ? !stdenv.isDarwin && !nixosTestRunner && !toolsOnly, SDL2, SDL2_image
, jackSupport ? !stdenv.isDarwin && !nixosTestRunner && !toolsOnly, libjack2
, gtkSupport ? !stdenv.isDarwin && !xenSupport && !nixosTestRunner && !toolsOnly, gtk3, gettext, vte, wrapGAppsHook
, vncSupport ? !nixosTestRunner && !toolsOnly, libjpeg, libpng
, smartcardSupport ? !nixosTestRunner && !toolsOnly, libcacard
, spiceSupport ? true && !nixosTestRunner && !toolsOnly, spice, spice-protocol
, ncursesSupport ? !nixosTestRunner && !toolsOnly, ncurses
, usbredirSupport ? spiceSupport, usbredir
, xenSupport ? false, xen
, cephSupport ? false, ceph
, glusterfsSupport ? false, glusterfs, libuuid
, openGLSupport ? sdlSupport, mesa, libepoxy, libdrm
, virglSupport ? openGLSupport, virglrenderer
, libiscsiSupport ? !toolsOnly, libiscsi
, smbdSupport ? false, samba
, tpmSupport ? !toolsOnly
, uringSupport ? stdenv.isLinux, liburing
, canokeySupport ? false, canokey-qemu
, capstoneSupport ? !toolsOnly, capstone
, enableDocs ? true
, hostCpuOnly ? false
, hostCpuTargets ? (if toolsOnly
                    then [ ]
                    else if hostCpuOnly
                    then (lib.optional stdenv.isx86_64 "i386-softmmu"
                          ++ ["${stdenv.hostPlatform.qemuArch}-softmmu"])
                    else null)
, nixosTestRunner ? false
, toolsOnly ? false
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
    + lib.optionalString toolsOnly "-utils";
  version = "8.1.5";

  src = fetchurl {
    url = "https://download.qemu.org/qemu-${finalAttrs.version}.tar.xz";
    hash = "sha256-l2Ox7+xP1JeWtQgNCINRLXDLY4nq1lxmHMNoalIjKJY=";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ]
    ++ lib.optionals hexagonSupport [ pkg-config ];

  nativeBuildInputs = [
    makeWrapper removeReferencesTo
    pkg-config flex bison meson ninja

    # Don't change this to python3 and python3.pkgs.*, breaks cross-compilation
    python3Packages.python python3Packages.sphinx python3Packages.sphinx-rtd-theme
  ]
    ++ lib.optionals gtkSupport [ wrapGAppsHook ]
    ++ lib.optionals hexagonSupport [ glib ]
    ++ lib.optionals stdenv.isDarwin [ sigtool ];

  buildInputs = [ zlib glib pixman
    vde2 texinfo lzo snappy libtasn1
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
    ++ lib.optionals stdenv.isLinux [ libaio libcap_ng libcap attr ]
    ++ lib.optionals xenSupport [ xen ]
    ++ lib.optionals cephSupport [ ceph ]
    ++ lib.optionals glusterfsSupport [ glusterfs libuuid ]
    ++ lib.optionals openGLSupport [ mesa libepoxy libdrm ]
    ++ lib.optionals virglSupport [ virglrenderer ]
    ++ lib.optionals libiscsiSupport [ libiscsi ]
    ++ lib.optionals smbdSupport [ samba ]
    ++ lib.optionals uringSupport [ liburing ]
    ++ lib.optionals canokeySupport [ canokey-qemu ]
    ++ lib.optionals capstoneSupport [ capstone ];

  dontUseMesonConfigure = true; # meson's configurePhase isn't compatible with qemu build

  outputs = [ "out" ] ++ lib.optional guestAgentSupport "ga";
  # On aarch64-linux we would shoot over the Hydra's 2G output limit.
  separateDebugInfo = !(stdenv.isAarch64 && stdenv.isLinux);

  patches = [
    (fetchpatch {
      name = "CVE-2024-3446.CVE-2024-3447.CVE-2024-3567.part-1.patch";
      url = "https://gitlab.com/qemu-project/qemu/-/commit/eb546a3f49f45e6870ec91d792cd09f8a662c16e.patch";
      hash = "sha256-YJCyTH/dtE3j1UnFkXB3COCKLhyeZlnHI+NCYC++urM=";
    })
    (fetchpatch {
      name = "CVE-2024-3446.CVE-2024-3447.CVE-2024-3567.part-2.patch";
      url = "https://gitlab.com/qemu-project/qemu/-/commit/1b2a52712b249e14d246cd9c7db126088e6e64db.patch";
      hash = "sha256-N7rvrYZEAXL/f5LhKrPYhzoV6dLdUMolNMvmJTdkTVk=";
    })
    (fetchpatch {
      name = "CVE-2024-3446.CVE-2024-3447.CVE-2024-3567.part-3.patch";
      url = "https://gitlab.com/qemu-project/qemu/-/commit/fbeb0a160cbcc067c0e1f0d380cea4a31de213e3.patch";
      hash = "sha256-fgB7tS0+303mHPpvNzvZT7xib6yCcVzvnGccFJnCTaY=";
    })
    (fetchpatch {
      name = "CVE-2024-3446.CVE-2024-3447.CVE-2024-3567.part-4.patch";
      url = "https://gitlab.com/qemu-project/qemu/-/commit/4f01537ced3e787bd985b8f8de5869b92657160a.patch";
      hash = "sha256-ssp/MefVQMfHh2q2m/MRzyu57D3q/cCiabOtUT/BQ0k=";
    })
    (fetchpatch {
      name = "CVE-2024-3446.CVE-2024-3447.CVE-2024-3567.part-5.patch";
      url = "https://gitlab.com/qemu-project/qemu/-/commit/5d53ff200b5b0e02473b4f38bb6ea74e781115d9.patch";
      hash = "sha256-UzPONq9AcmdXK+c40eftJA7JRiNiprM4U9Na78fFp+8=";
    })
    (fetchpatch {
      name = "CVE-2024-3446.CVE-2024-3447.CVE-2024-3567.part-6.patch";
      url = "https://gitlab.com/qemu-project/qemu/-/commit/15b41461ea7386005194d79d0736f1975c6301d7.patch";
      hash = "sha256-dXBbWh0ep6+oEXE/i51m6r0iX19qISpmLy2Uw/rtR0I=";
    })
    (fetchpatch {
      name = "CVE-2024-3446.CVE-2024-3447.CVE-2024-3567.part-7.patch";
      url = "https://gitlab.com/qemu-project/qemu/-/commit/ab995895adcf30d0be416da281a0bcf3dd3f93a5.patch";
      hash = "sha256-74xgr+mZ/EPdv/919G/useydya58mHczca8AZkobg5Q=";
    })
    (fetchpatch {
      name = "CVE-2024-3446.CVE-2024-3447.CVE-2024-3567.part-8.patch";
      url = "https://gitlab.com/qemu-project/qemu/-/commit/6e7e387b7931d8f6451128ed06f8bca8ffa64fda.patch";
      hash = "sha256-nj12/4EzZnLfL6NjX2X0dnXa42ESmqVuk8NcU7gZtTQ=";
    })
    (fetchpatch {
      name = "CVE-2024-3446.CVE-2024-3447.CVE-2024-3567.part-9.patch";
      url = "https://gitlab.com/qemu-project/qemu/-/commit/1c5005c450928c77056621a561568cdea2ee24db.patch";
      hash = "sha256-sAaQwv/JY8IWhNQcvFMl0w4c1AqiVGuZJ/a0OLhFx2s=";
    })
    (fetchpatch {
      name = "CVE-2024-3446.CVE-2024-3447.CVE-2024-3567.part-10.patch";
      url = "https://gitlab.com/qemu-project/qemu/-/commit/516bdbc2341892fb3b3173ec393c6dfc9515608f.patch";
      hash = "sha256-VTD8QlqPUs+QZMBU9qisilpClYMvSJY9J0dsUFods5M=";
    })
    (fetchpatch {
      name = "CVE-2024-3446.CVE-2024-3447.CVE-2024-3567.part-11.patch";
      url = "https://gitlab.com/qemu-project/qemu/-/commit/4e6240e184cd6303b7275118c7d574c973a3be35.patch";
      hash = "sha256-NlgzWoWmik4aDGuYiZlvn28HL2ZhBcjv7TgC5Wo+Vrk=";
    })
    (fetchpatch {
      name = "CVE-2024-3446.CVE-2024-3447.CVE-2024-3567.part-12.patch";
      url = "https://gitlab.com/qemu-project/qemu/-/commit/9666bd2b7967182d7891e83187f41f0ae3c3cb05.patch";
      hash = "sha256-w+ZSXkME6wtsYlDE9ELHl6CjvkLjRtTuxqF15u5mQWU=";
    })
    (fetchpatch {
      name = "CVE-2024-3446.CVE-2024-3447.CVE-2024-3567.part-13.patch";
      url = "https://gitlab.com/qemu-project/qemu/-/commit/35a67d2aa8caf8eb0bee7d38515924c95417047e.patch";
      hash = "sha256-3kL8HMjTe3mbvb7K07zJOHbp676oBsynLi24k2N1iBY=";
    })
    (fetchpatch {
      name = "CVE-2024-3446.CVE-2024-3447.CVE-2024-3567.part-14.patch";
      url = "https://gitlab.com/qemu-project/qemu/-/commit/1cfe45956e03070f894e91b304e233b4d5b99719.patch";
      hash = "sha256-jnZ/kvKugCc5EjETuyXQ8v3zlpkay1J9BaopmlRIRgE=";
    })

    ./fix-qemu-ga.patch

    # QEMU upstream does not demand compatibility to pre-10.13, so 9p-darwin
    # support on nix requires utimensat fallback. The patch adding this fallback
    # set was removed during the process of upstreaming this functionality, and
    # will still be needed in nix until the macOS SDK reaches 10.13+.
    ./provide-fallback-for-utimensat.patch
    # Cocoa clipboard support only works on macOS 10.14+
    ./revert-ui-cocoa-add-clipboard-support.patch
    # Standard about panel requires AppKit and macOS 10.13+
    (fetchpatch {
      url = "https://gitlab.com/qemu-project/qemu/-/commit/99eb313ddbbcf73c1adcdadceba1423b691c6d05.diff";
      sha256 = "sha256-gTRf9XENAfbFB3asYCXnw4OV4Af6VE1W56K2xpYDhgM=";
      revert = true;
    })
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
    "--enable-tools"
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
    ++ lib.optional uringSupport "--enable-linux-io-uring"
    ++ lib.optional canokeySupport "--enable-canokey"
    ++ lib.optional capstoneSupport "--enable-capstone";

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
  '' + lib.optionalString stdenv.isDarwin ''
    # skip test that stalls on darwin, perhaps due to subtle differences
    # in fifo behaviour
    substituteInPlace ../tests/unit/meson.build \
      --replace "'test-io-channel-command'" "#'test-io-channel-command'"
  '';

  # Add a ‘qemu-kvm’ wrapper for compatibility/convenience.
  postInstall = lib.optionalString (!toolsOnly) ''
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
    description = "A generic and open source machine emulator and virtualizer";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ eelco qyliss ];
    platforms = platforms.unix;
  }
  # toolsOnly: Does not have qemu-kvm and there's no main support tool
  // lib.optionalAttrs (!toolsOnly) {
    mainProgram = "qemu-kvm";
  };
})
