{
  lib,
  stdenv,
  fetchzip,
  buildFHSEnv,
  makeDesktopItem,
  makeWrapper,
  autoPatchelfHook,
  stdenvNoCC,
  imagemagick,
  # buildInputs
  alsa-lib,
  at-spi2-atk,
  cairo,
  cups,
  dbus,
  expat,
  fakeroot,
  freetype,
  glib,
  gtk3,
  libusb-compat-0_1,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxkbcommon,
  libxrandr,
  libxtst,
  mesa,
  nspr,
  nss,
  pango,
  systemd,
  # FHS runtime deps (dlopen'd)
  libGL,
  libxkbfile,
  # parameters
  enabled-components ? [
    "PF_AM13X"
    "PF_ARM_MPU"
    "PF_AUTO"
    "PF_C28"
    "PF_C6000SC"
    "PF_DIGITAL_POWER"
    "PF_HERCULES"
    "PF_MMWAVE"
    "PF_MSP430"
    "PF_MSP432"
    "PF_MSPM0"
    "PF_MSPM33"
    "PF_OMAPL"
    "PF_PGA"
    "PF_SITARA_MCU"
    "PF_TM4C"
    "PF_WCONN"
  ],
}:

let
  # Minimal FHS environment for the installer.
  # The .run binary and its sub-installers (extracted at runtime) are native
  # ELFs expecting /lib64/ld-linux-x86-64.so.2. We can't patchelf the
  # sub-installers since they don't exist until the main installer runs.
  # buildFHSEnv provides the dynamic linker even with an empty targetPkgs.
  #
  # extraBwrapArgs:
  #   --proc /proc: installer reads /proc/self for path resolution
  #   --bind .../etc/udev/rules.d: Blackhawk post-install copies udev rules here
  fhsInstallerEnv = buildFHSEnv {
    name = "ccs-installer-env";
    targetPkgs = _: [ ];
    runScript = "bash";
    extraPreBwrapCmds = ''
      mkdir -p /tmp/fake-udev-rules
    '';
    extraBwrapArgs = [
      "--proc /proc"
      "--bind /tmp/fake-udev-rules /etc/udev/rules.d"
    ];
  };

  package = stdenvNoCC.mkDerivation rec {
    pname = "ccstudio";
    version-short = "21.0.0";
    version = "${version-short}.00014";

    strictDeps = true;
    __structuredAttrs = true;

    src = fetchzip {
      url = "https://dr-download.ti.com/software-development/ide-configuration-compiler-or-debugger/MD-J1VdearkvK/${version-short}/CCS_${version}_linux.zip";
      sha256 = "sha256-0qkXYkm9NH9XscarNzr01XVnin/+nezIe0lxsgO1rWc=";
    };

    nativeBuildInputs = [
      autoPatchelfHook
      fakeroot
      imagemagick
      makeWrapper
    ];

    buildInputs = [
      alsa-lib
      at-spi2-atk
      cairo
      cups
      dbus
      expat
      freetype
      glib
      gtk3
      libusb-compat-0_1 # provides libusb-0.1.so.4 needed by sd560v2u and mspdebug
      libx11
      libxcb
      libxcomposite
      libxdamage
      libxext
      libxfixes
      libxkbcommon
      libxrandr
      libxtst
      mesa # provides libgbm.so.1
      nspr
      nss
      pango
      stdenv.cc.cc.lib
      systemd
    ];

    desktopItem = makeDesktopItem {
      name = "ccstudio";
      exec = "ccstudio";
      icon = "ccstudio";
      desktopName = "Code Composer Studio 21";
      comment = "TI Code Composer Studio IDE for embedded development";
      categories = [
        "Development"
        "IDE"
      ];
      terminal = false;
      startupWMClass = "ccstudio";
    };

    # musl prebuilds: serialport/usb ship both glibc and musl .node files;
    # we only use glibc, so musl deps are unsatisfiable and safe to ignore.
    # libpython3.9: FlashPythonSubprocess is linked against python 3.9
    # specifically (versioned soname); it won't work without that exact
    # version. This is an optional scripting tool most users don't need.
    autoPatchelfIgnoreMissingDeps = [
      "libc.musl-x86_64.so.1"
      "libpython3.9.so.1.0"
    ];

    # Run the installer and patch the result.
    # The .zip contains a proprietary InstallBuilder .run binary and .pak
    # component files (not standard archives), so they must be unpacked by
    # the installer itself.
    #
    # Key workarounds:
    #   - fakeroot: makes the Blackhawk emupack post-install believe it runs as
    #     root (it aborts otherwise)
    #   - Fake `service`: the Blackhawk post-install tries to restart some
    #     services, so we no-op it
    buildPhase = ''
      export TMPDIR=$(mktemp -d)

      mkdir -p $TMPDIR/fakebin
      printf '#!/bin/bash\nexit 0\n' > $TMPDIR/fakebin/service
      chmod +x $TMPDIR/fakebin/service

      ${fhsInstallerEnv}/bin/ccs-installer-env -c "
        export PATH=$TMPDIR/fakebin:\$PATH

        cd $PWD
        fakeroot ./ccs_setup_${version}.run \
          --mode unattended \
          --prefix $out/opt/ccstudio \
          --debuglevel 4 \
          --debugtrace $TMPDIR/ccs_install_debug.log \
          --enable-components ${lib.concatStringsSep "," enabled-components}
      "

      mkdir -p $out/bin

      ccs_bin=$out/opt/ccstudio/ccs/theia/ccstudio

      # The debug server dlopen's sibling .so files (libxdsboard, libprsc,
      # libcmapi) at runtime. autoPatchelfHook rewrites RPATH to only Nix
      # store deps, so we need to restore the internal CCS library paths.
      makeWrapper "$ccs_bin" $out/bin/ccstudio \
        --prefix LD_LIBRARY_PATH : "$out/opt/ccstudio/ccs/ccs_base/common/uscif" \
        --prefix LD_LIBRARY_PATH : "$out/opt/ccstudio/ccs/ccs_base/common/bin" \
        --prefix LD_LIBRARY_PATH : "$out/opt/ccstudio/ccs/ccs_base/emulation/drivers" \
        --prefix LD_LIBRARY_PATH : "$out/opt/ccstudio/ccs/ccs_base/DebugServer/bin"

      # Desktop entry
      mkdir -p $out/share/applications
      cp ${desktopItem}/share/applications/* $out/share/applications/

      # Icons
      for size in 16 24 32 48 64 128 256; do
        mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
        magick $out/opt/ccstudio/ccs/doc/ccs.png \
          -resize "$size"x"$size" \
          $out/share/icons/hicolor/"$size"x"$size"/apps/ccstudio.png
      done
    '';

    meta = with lib; {
      description = "TI Code Composer Studio IDE for embedded development";
      longDescription = ''
        CCStudio™ IDE is part of TI's extensive CCStudio™ development ecosystem
        and is an integrated development environment for TI's microcontrollers,
        processors, wireless connectivity devices, and radar sensors.
      '';
      homepage = "https://www.ti.com/tool/CCSTUDIO";
      license = licenses.unfree;
      platforms = [ "x86_64-linux" ];
      maintainers = with lib.maintainers; [ bjsowa ];
    };
  };

  # Runtime FHS wrapper.
  # autoPatchelfHook resolves most library deps via RPATH, but some libraries are
  # dlopen'd at runtime from system paths.
in
(buildFHSEnv {
  inherit (package) pname version meta;

  runScript = "${package}/bin/ccstudio";
  extraInstallCommands = ''
    mkdir -p $out/share
    ln -sf ${package}/share/applications $out/share/applications
    ln -sf ${package}/share/icons $out/share/icons
  '';
  targetPkgs = _: [
    # dlopen'd at runtime
    libGL
    libxkbfile
  ];
}).overrideAttrs
  (_: {
    strictDeps = true;
    __structuredAttrs = true;
  })
