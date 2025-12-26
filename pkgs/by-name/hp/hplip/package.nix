{
  lib,
  stdenv,
  fetchurl,
  replaceVars,
  pkg-config,
  autoreconfHook,
  gobject-introspection,
  wrapGAppsHook3,
  cups,
  zlib,
  libjpeg,
  libusb1,
  python3Packages,
  sane-backends,
  dbus,
  file,
  ghostscript,
  usbutils,
  net-snmp,
  openssl,
  perl,
  net-tools,
  avahi,
  bash,
  util-linux,
  # To remove references to gcc-unwrapped
  removeReferencesTo,
  qt5,
  withQt5 ? true,
  withPlugin ? false,
  withStaticPPDInstall ? false,
}:

let

  pname = "hplip";
  version = "3.25.2";

  src = fetchurl {
    url = "mirror://sourceforge/hplip/${pname}-${version}.tar.gz";
    hash = "sha256-6HL/KOslF3Balfbhg576HlCnejOq6JBSeN8r2CCRllM=";
  };

  plugin = fetchurl {
    url = "https://www.openprinting.org/download/printdriver/auxfiles/HP/plugins/${pname}-${version}-plugin.run";
    hash = "sha256-miz41WYehGVI27tZUjGlRIpctjcpzJPfjR9lLf0WelQ=";
  };

  hplipState = replaceVars ./hplip.state {
    inherit version;
  };

  hplipPlatforms = {
    i686-linux = "x86_32";
    x86_64-linux = "x86_64";
    armv6l-linux = "arm32";
    armv7l-linux = "arm32";
    aarch64-linux = "arm64";
  };

  hplipArch =
    hplipPlatforms.${stdenv.hostPlatform.system}
      or (throw "HPLIP not supported on ${stdenv.hostPlatform.system}");

  pluginArches = [
    "x86_32"
    "x86_64"
    "arm32"
    "arm64"
  ];

in

python3Packages.buildPythonApplication {
  inherit pname version;
  format = "other";

  srcs = [ src ] ++ lib.optional withPlugin plugin;

  unpackCmd = lib.optionalString withPlugin ''
    if ! [[ "$curSrc" =~ -plugin\.run$ ]]; then return 1; fi # fallback to regular unpackCmdHooks

    # Unpack plugin shar
    sh "$curSrc" --noexec --keep
  '';

  sourceRoot = "${pname}-${version}";

  buildInputs = [
    libjpeg
    cups
    libusb1
    sane-backends
    dbus
    file
    ghostscript
    net-snmp
    openssl
    perl
    zlib
    avahi
  ]
  ++ lib.optionals withQt5 [
    qt5.qtwayland
  ];

  nativeBuildInputs = [
    pkg-config
    removeReferencesTo
    autoreconfHook
    gobject-introspection
    wrapGAppsHook3
  ]
  ++ lib.optional withQt5 qt5.wrapQtAppsHook;

  pythonPath =
    with python3Packages;
    [
      dbus
      pillow
      pygobject3
      reportlab
      usbutils
      dbus-python
      distro
      distutils
    ]
    ++ lib.optionals withQt5 [
      pyqt5
      pyqt5-sip
    ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    "${net-tools}/bin"
  ];

  patches = [
    # HPLIP's getSystemPPDs() function relies on searching for PPDs below common FHS
    # paths, and hp-setup crashes if none of these paths actually exist (which they
    # don't on NixOS).  Add the equivalent NixOS path, /var/lib/cups/path/share.
    # See: https://github.com/NixOS/nixpkgs/issues/21796
    ./hplip-3.20.11-nixos-cups-ppd-search-path.patch

    # Remove all ImageProcessor functionality since that is closed source
    (fetchurl {
      url = "https://web.archive.org/web/20230226174550/https://sources.debian.org/data/main/h/hplip/3.22.10+dfsg0-1/debian/patches/0028-Remove-ImageProcessor-binary-installs.patch";
      hash = "sha256-tNYccuwrcx5WCe7ULk8r8J6MVcUytGspiW64zAvO0qI=";
    })
  ];

  postPatch = ''
    # https://github.com/NixOS/nixpkgs/issues/44230
    substituteInPlace createPPD.sh \
      --replace-fail ppdc "${cups}/bin/ppdc" \
      --replace-fail "gzip -c" "gzip -cn"

    # HPLIP hardcodes absolute paths everywhere. Nuke from orbit.
    find . -type f -exec sed -i \
      -e s,/etc/hp,$out/etc/hp,g \
      -e s,/etc/sane.d,$out/etc/sane.d,g \
      -e s,/usr/include/libusb-1.0,${libusb1.dev}/include/libusb-1.0,g \
      -e s,/usr/share/hal/fdi/preprobe/10osvendor,$out/share/hal/fdi/preprobe/10osvendor,g \
      -e s,/usr/lib/systemd/system,$out/lib/systemd/system,g \
      -e s,/var/lib/hp,$out/var/lib/hp,g \
      -e s,/usr/bin/perl,${perl}/bin/perl,g \
      -e s,/usr/bin/file,${file}/bin/file,g \
      -e s,/usr/bin/gs,${ghostscript}/bin/gs,g \
      -e s,/usr/share/cups/fonts,${ghostscript.fonts}/share/fonts,g \
      -e "s,ExecStart=/usr/bin/python /usr/bin/hp-config_usb_printer,ExecStart=$out/bin/hp-config_usb_printer,g" \
      -e s,Exec=/usr/bin/hp-uiscan,Exec=hp-uiscan,g \
      -e s,Icon=/usr/share/icons/Humanity/devices/48/printer.svg,Icon=printer,g \
      -e s,Icon=@abs_datadir@/hplip/data/images/128x128/hp_logo.png,Icon=hp_logo,g \
      {} +

    echo 'AUTOMAKE_OPTIONS = foreign' >> Makefile.am
  '';

  configureFlags =
    let
      out = placeholder "out";
    in
    [
      "--with-hpppddir=${out}/share/cups/model/HP"
      "--with-cupsfilterdir=${out}/lib/cups/filter"
      "--with-cupsbackenddir=${out}/lib/cups/backend"
      "--with-icondir=${out}/share/applications"
      "--with-systraydir=${out}/xdg/autostart"
      "--with-mimedir=${out}/etc/cups"
      "--enable-policykit"
      "--disable-qt4"

      # remove ImageProcessor usage, it causes segfaults, see
      # https://bugs.launchpad.net/hplip/+bug/1788706
      # https://bugs.launchpad.net/hplip/+bug/1787289
      "--disable-imageProcessor-build"
    ]
    ++ lib.optional withStaticPPDInstall "--enable-cups-ppd-install"
    ++ lib.optional withQt5 "--enable-qt5";

  # Prevent 'ppdc: Unable to find include file "<font.defs>"' which prevent
  # generation of '*.ppd' files.
  # This seems to be a 'ppdc' issue when the tool is run in a hermetic sandbox.
  # Could not find how to fix the problem in 'ppdc' so this is a workaround.
  CUPS_DATADIR = "${cups}/share/cups";

  makeFlags =
    let
      out = placeholder "out";
    in
    [
      "halpredir=${out}/share/hal/fdi/preprobe/10osvendor"
      "rulesdir=${out}/etc/udev/rules.d"
      "policykit_dir=${out}/share/polkit-1/actions"
      "policykit_dbus_etcdir=${out}/etc/dbus-1/system.d"
      "policykit_dbus_sharedir=${out}/share/dbus-1/system-services"
      "PYTHONEXECDIR=${out}/lib/python${lib.versions.majorMinor python3Packages.python.version}/site-packages"
      "hplip_confdir=${out}/etc/hp"
      "hplip_statedir=${out}/var/lib/hp"
    ];

  postConfigure = ''
    # don't save timestamp, in order to improve reproducibility
    substituteInPlace Makefile \
      --replace "GZIP_ENV = --best" "GZIP_ENV = --best -n"
  '';

  enableParallelBuilding = true;
  enableParallelInstalling = false;

  env = {
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=implicit-int"
      "-Wno-error=implicit-function-declaration"
      "-Wno-error=return-mismatch"
      "-Wno-error=int-conversion"
      "-Wno-error=incompatible-pointer-types"
    ];
  };

  #
  # Running `hp-diagnose_plugin -g` can be used to diagnose
  # issues with plugins.
  #
  postInstall = ''
    for resolution in 16x16 32x32 64x64 128x128 256x256; do
      mkdir -p $out/share/icons/hicolor/$resolution/apps
      ln -s $out/share/hplip/data/images/$resolution/hp_logo.png \
        $out/share/icons/hicolor/$resolution/apps/hp_logo.png
    done
  ''
  + lib.optionalString withPlugin ''
    pushd $NIX_BUILD_TOP/plugin_tmp

    cp plugin.spec $out/share/hplip/

    mkdir -p $out/share/hplip/data/firmware
    cp *.fw.gz $out/share/hplip/data/firmware

    mkdir -p $out/share/hplip/data/plugins
    cp license.txt $out/share/hplip/data/plugins

    mkdir -p $out/share/hplip/prnt/plugins
    for plugin in lj hbpl1; do
      cp $plugin-${hplipArch}.so $out/share/hplip/prnt/plugins
      chmod 0755 $out/share/hplip/prnt/plugins/$plugin-${hplipArch}.so
      ln -s $out/share/hplip/prnt/plugins/$plugin-${hplipArch}.so \
        $out/share/hplip/prnt/plugins/$plugin.so
    done

    mkdir -p $out/share/hplip/scan/plugins
    for plugin in bb_soap bb_marvell bb_soapht bb_escl; do
      cp $plugin-${hplipArch}.so $out/share/hplip/scan/plugins
      chmod 0755 $out/share/hplip/scan/plugins/$plugin-${hplipArch}.so
      ln -s $out/share/hplip/scan/plugins/$plugin-${hplipArch}.so \
        $out/share/hplip/scan/plugins/$plugin.so
    done

    mkdir -p $out/share/hplip/fax/plugins
    for plugin in fax_marvell; do
      cp $plugin-${hplipArch}.so $out/share/hplip/fax/plugins
      chmod 0755 $out/share/hplip/fax/plugins/$plugin-${hplipArch}.so
      ln -s $out/share/hplip/fax/plugins/$plugin-${hplipArch}.so \
        $out/share/hplip/fax/plugins/$plugin.so
    done

    mkdir -p $out/var/lib/hp
    cp ${hplipState} $out/var/lib/hp/hplip.state

    popd
  '';

  # The installed executables are just symlinks into $out/share/hplip,
  # but wrapPythonPrograms ignores symlinks. We cannot replace the Python
  # modules in $out/share/hplip with wrapper scripts because they import
  # each other as libraries. Instead, we emulate wrapPythonPrograms by
  # 1. Calling patchPythonProgram on the original script in $out/share/hplip
  # 2. Making our own wrapper pointing directly to the original script.
  dontWrapPythonPrograms = true;
  # We also avoid double (or triple in case qt5 support is added) wrapping
  dontWrapGApps = true;
  dontWrapQtApps = true;
  preFixup = ''
    buildPythonPath "$out $pythonPath"

    for bin in $out/bin/*; do
      py=$(readlink -m $bin)
      rm $bin
      echo "patching \`$py'..."
      patchPythonScript "$py"
      echo "wrapping \`$bin'..."
      ${if withQt5 then "makeQtWrapper" else "makeWrapper"} "$py" "$bin" \
          --prefix PATH ':' "$program_PATH" \
          --set PYTHONNOUSERSITE "true" \
          $makeWrapperArgs "''${gappsWrapperArgs[@]}"
    done
  '';

  postFixup = ''
    substituteInPlace $out/etc/hp/hplip.conf --replace /usr $out
    # Patch udev rules:
    # with plugin, they upload firmware to printers,
    # without plugin, they complain about the missing plugin.
    substituteInPlace $out/etc/udev/rules.d/56-hpmud.rules \
      --replace {,${bash}}/bin/sh \
      --replace /usr/bin/nohup "" \
      --replace {,${util-linux}/bin/}logger \
      --replace {/usr,$out}/bin
    remove-references-to -t ${stdenv.cc.cc} $(readlink -f $out/lib/*.so)
  '';

  # There are some binaries there, which reference gcc-unwrapped otherwise.
  stripDebugList = [
    "share/hplip"
    "lib/cups/backend"
    "lib/cups/filter"
    python3Packages.python.sitePackages
    "lib/sane"
  ];

  meta = {
    description = "Print, scan and fax HP drivers for Linux";
    homepage = "https://developers.hp.com/hp-linux-imaging-and-printing";
    downloadPage = "https://sourceforge.net/projects/hplip/files/hplip/";
    license =
      if withPlugin then
        lib.licenses.unfree
      else
        with lib.licenses;
        [
          mit
          bsd2
          gpl2Plus
        ];
    platforms = lib.attrNames hplipPlatforms;
    maintainers = with lib.maintainers; [ ttuegel ];
  };
}
