{
  lib,
  stdenv,
  fetchurl,
  buildPackages,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  dpkg,
  expat,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  adwaita-icon-theme,
  gsettings-desktop-schemas,
  gtk3,
  gtk4,
  qt6,
  libx11,
  libxscrnsaver,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxi,
  libxrandr,
  libxrender,
  libxtst,
  libdrm,
  libkrb5,
  libuuid,
  libxkbcommon,
  libxshmfence,
  libgbm,
  nspr,
  nss,
  pango,
  pipewire,
  snappy,
  udev,
  wayland,
  xdg-utils,
  coreutils,
  libxcb,
  zlib,

  # Darwin dependencies
  unzip,
  makeWrapper,

  # command line arguments which are always set e.g "--disable-gpu"
  commandLineArgs ? "",

  # Necessary for USB audio devices.
  pulseSupport ? stdenv.hostPlatform.isLinux,
  libpulseaudio,

  # For GPU acceleration support on Wayland (without the lib it doesn't seem to work)
  libGL,

  # For video acceleration via VA-API (--enable-features=AcceleratedVideoDecodeLinuxGL,AcceleratedVideoEncoder)
  libvaSupport ? stdenv.hostPlatform.isLinux,
  libva,
  enableVideoAcceleration ? libvaSupport,

  # For Vulkan support (--enable-features=Vulkan); disabled by default as it seems to break VA-API
  vulkanSupport ? false,
  addDriverRunpath,
  enableVulkan ? vulkanSupport,
}:

{
  pname,
  version,
  # Map from Nix system strings ("x86_64-linux", "aarch64-darwin", ...) to
  # the corresponding upstream `{ url, hash }` record. Encoding the per-system
  # sources as data rather than positional arguments lets channel-specific
  # package.nix files drop platforms that upstream hasn't published yet.
  archives,
  # Release channel: "stable", "beta" or "nightly". Selects the upstream
  # filesystem layout (opt directory, desktop files, icon names, darwin app
  # bundle name) produced by the matching .deb / .zip artifact.
  channel ? "stable",
  # Upstream product flavor: "browser" (the regular Brave) or "origin" (the
  # stripped-down Brave Origin). Origin has no stable channel upstream, so
  # flavor = "origin" implies channel != "stable".
  flavor ? "browser",
}:

let
  inherit (lib)
    optional
    optionals
    makeLibraryPath
    makeSearchPathOutput
    makeBinPath
    optionalString
    strings
    escapeShellArg
    ;

  # Flavor-specific naming stems. browser follows the historical Brave layout;
  # origin uses a parallel tree under /opt/brave.com/brave-origin-<channel>/.
  flavorData = {
    browser = {
      optStem = "brave";
      fileStem = "brave-browser";
      appIdStem = "com.brave.Browser";
      darwinStem = "Brave Browser";
      changelogFile = "CHANGELOG_DESKTOP.md";
      # browser ships its icons with a channel suffix in the filename.
      iconsCarryChannelSuffix = true;
      homepages = {
        stable = "https://brave.com/";
        beta = "https://brave.com/download-beta/";
        nightly = "https://brave.com/download-nightly/";
      };
    };
    origin = {
      optStem = "brave-origin";
      fileStem = "brave-origin";
      appIdStem = "com.brave.Origin";
      darwinStem = "Brave Origin";
      changelogFile = "CHANGELOG_DESKTOP_ORIGIN.md";
      # origin keeps icons un-suffixed, because the parent directory already
      # encodes the channel.
      iconsCarryChannelSuffix = false;
      homepages = {
        beta = "https://brave.com/origin/download-beta/";
        nightly = "https://brave.com/origin/download-nightly/";
      };
    };
  };

  fd = flavorData.${flavor};

  # Suffix used by upstream for non-stable channels.
  channelDashSuffix = if channel == "stable" then "" else "-${channel}";
  channelDotSuffix = if channel == "stable" then "" else ".${channel}";
  channelSpaceSuffix =
    if channel == "stable" then
      ""
    else
      " ${lib.toUpper (lib.substring 0 1 channel)}${lib.substring 1 (-1) channel}";

  # /opt/brave.com/<optName>/
  optName = fd.optStem + channelDashSuffix;
  # Basename used for .desktop, gnome-control-center xml and icon files.
  fileBase = fd.fileStem + channelDashSuffix;
  # Secondary .desktop app-id.
  appId = fd.appIdStem + channelDotSuffix;
  # Upstream shell wrapper inside /opt.
  innerWrapper = fileBase;
  # macOS .app bundle name (inside the zip).
  darwinApp = fd.darwinStem + channelSpaceSuffix;
  # Upstream Exec= target in .desktop files (replaced with our wrapper).
  # browser-stable uniquely uses "brave-browser-stable" rather than the plain
  # filename stem; every other combination matches `fileBase`.
  upstreamBin =
    if flavor == "browser" && channel == "stable" then "brave-browser-stable" else fileBase;
  # Upstream icon filename suffix ("_beta", "_nightly", or empty).
  iconSuffix = if fd.iconsCarryChannelSuffix && channel != "stable" then "_${channel}" else "";

  deps = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    gtk4
    libdrm
    libx11
    libGL
    libxkbcommon
    libxscrnsaver
    libxcomposite
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxi
    libxrandr
    libxrender
    libxshmfence
    libxtst
    libuuid
    libgbm
    nspr
    nss
    pango
    pipewire
    udev
    wayland
    libxcb
    zlib
    snappy
    libkrb5
    qt6.qtbase
  ]
  ++ optional pulseSupport libpulseaudio
  ++ optional libvaSupport libva;

  rpath = makeLibraryPath deps + ":" + makeSearchPathOutput "lib" "lib64" deps;
  binpath = makeBinPath deps;

  enableFeatures =
    optionals enableVideoAcceleration [
      "AcceleratedVideoDecodeLinuxGL"
      "AcceleratedVideoEncoder"
    ]
    ++ optional enableVulkan "Vulkan";

  disableFeatures = [
    "OutdatedBuildDetector"
  ] # disable automatic updates
  # The feature disable is needed for VAAPI to work correctly: https://github.com/brave/brave-browser/issues/20935
  ++ optionals enableVideoAcceleration [ "UseChromeOSDirectVideoDecoder" ];

  archive =
    assert lib.assertMsg (builtins.hasAttr stdenv.hostPlatform.system archives)
      "${pname} is not available for ${stdenv.hostPlatform.system}";
    archives.${stdenv.hostPlatform.system};
in
stdenv.mkDerivation {
  inherit pname version;

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl { inherit (archive) url hash; };

  dontConfigure = true;
  dontBuild = true;
  dontPatchELF = true;
  doInstallCheck = stdenv.hostPlatform.isLinux;

  nativeBuildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      dpkg
      # override doesn't preserve splicing https://github.com/NixOS/nixpkgs/issues/132651
      # Has to use `makeShellWrapper` from `buildPackages` even though `makeShellWrapper` from the inputs is spliced because `propagatedBuildInputs` would pick the wrong one because of a different offset.
      (buildPackages.wrapGAppsHook3.override { makeWrapper = buildPackages.makeShellWrapper; })
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      unzip
      makeWrapper
    ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    # needed for GSETTINGS_SCHEMAS_PATH
    glib
    gsettings-desktop-schemas
    gtk3
    gtk4

    # needed for XDG_ICON_DIRS
    adwaita-icon-theme
  ];

  installPhase =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      runHook preInstall

      mkdir -p $out $out/bin

      cp -R usr/share $out
      cp -R opt/ $out/opt

      export BINARYWRAPPER=$out/opt/brave.com/${optName}/${innerWrapper}

      # Fix path to bash in $BINARYWRAPPER
      substituteInPlace $BINARYWRAPPER \
          --replace-fail /bin/bash ${stdenv.shell} \
          --replace-fail 'CHROME_WRAPPER' 'WRAPPER'

      ln -sf $BINARYWRAPPER $out/bin/${pname}

      for exe in $out/opt/brave.com/${optName}/{brave,chrome_crashpad_handler}; do
          patchelf \
              --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
              --set-rpath "${rpath}" $exe
      done

      # Fix paths
      substituteInPlace $out/share/applications/{${fileBase},${appId}}.desktop \
          --replace-fail /usr/bin/${upstreamBin} $out/bin/${pname}
      substituteInPlace $out/share/gnome-control-center/default-apps/${fileBase}.xml \
          --replace-fail /opt/brave.com $out/opt/brave.com
      substituteInPlace $out/opt/brave.com/${optName}/default-app-block \
          --replace-fail /opt/brave.com $out/opt/brave.com

      # Correct icons location
      icon_sizes=("16" "24" "32" "48" "64" "128" "256")

      for icon in ''${icon_sizes[*]}
      do
          mkdir -p $out/share/icons/hicolor/''${icon}x''${icon}/apps
          ln -s $out/opt/brave.com/${optName}/product_logo_''${icon}${iconSuffix}.png $out/share/icons/hicolor/''${icon}x''${icon}/apps/${fileBase}.png
      done

      # Replace xdg-settings and xdg-mime
      ln -sf ${xdg-utils}/bin/xdg-settings $out/opt/brave.com/${optName}/xdg-settings
      ln -sf ${xdg-utils}/bin/xdg-mime $out/opt/brave.com/${optName}/xdg-mime

      runHook postInstall
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      runHook preInstall

      mkdir -p $out/{Applications,bin}

      cp -r . "$out/Applications/${darwinApp}.app"

      makeWrapper "$out/Applications/${darwinApp}.app/Contents/MacOS/${darwinApp}" $out/bin/${pname}

      runHook postInstall
    '';

  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    # Add command line args to wrapGApp.
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : ${rpath}
      --prefix PATH : ${binpath}
      --suffix PATH : ${
        lib.makeBinPath [
          xdg-utils
          coreutils
        ]
      }
      --set CHROME_WRAPPER ${pname}
      ${optionalString (enableFeatures != [ ]) ''
        --add-flags "--enable-features=${strings.concatStringsSep "," enableFeatures}\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+,WaylandWindowDecorations --enable-wayland-ime=true}}"
      ''}
      ${optionalString (disableFeatures != [ ]) ''
        --add-flags "--disable-features=${strings.concatStringsSep "," disableFeatures}"
      ''}
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto}}"
      ${optionalString vulkanSupport ''
        --prefix XDG_DATA_DIRS  : "${addDriverRunpath.driverLink}/share"
      ''}
      --add-flags ${escapeShellArg commandLineArgs}
    )
  '';

  installCheckPhase = ''
    # Bypass upstream wrapper which suppresses errors
    $out/opt/brave.com/${optName}/brave --version
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = fd.homepages.${channel};
    description =
      "Privacy-oriented browser for Desktop and Laptop computers"
      + lib.optionalString (flavor == "origin") " (Origin variant)"
      + lib.optionalString (channel != "stable") " (${channel} channel)";
    changelog =
      "https://github.com/brave/brave-browser/blob/master/${fd.changelogFile}#"
      + lib.replaceStrings [ "." ] [ "" ] version;
    longDescription =
      if flavor == "origin" then
        ''
          Brave Origin is a stripped-down variant of the Brave browser that
          removes most non-privacy features (rewards, wallet, AI, etc.) while
          keeping the core privacy, adblock and Chromium-based browsing
          experience.
        ''
      else
        ''
          Brave browser blocks the ads and trackers that slow you down,
          chew up your bandwidth, and invade your privacy. Brave lets you
          contribute to your favorite creators automatically.
        '';
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      uskudnik
      rht
      jefflabonte
      nasirhm
      buckley310
      Dreaming-Codes
    ];
    platforms = builtins.attrNames archives;
    mainProgram = pname;
  };
}
