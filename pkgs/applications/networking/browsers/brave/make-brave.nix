{
  pname,
  version,
  # Map from Nix system strings ("x86_64-linux", "aarch64-darwin", ...) to
  # the corresponding upstream `{ url, hash }` record. Encoding the per-system
  # sources as data rather than positional arguments lets channel-specific
  # package.nix files drop platforms that upstream hasn't published yet.
  archives,
  # Upstream product flavor: "browser" (the regular Brave) or "origin" (the
  # stripped-down Brave Origin).
  flavor ? "browser",
  # Flavor-specific paths supplied by the caller (default.nix).
  optStem,
  fileStem,
  appIdStem,
  darwinStem,
  changelogFile,
  homepage,
  innerBinary,
}:

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

  # /opt/brave.com/<optName>/
  optName = optStem;
  # Basename used for .desktop, gnome-control-center xml and icon files.
  fileBase = fileStem;
  # Secondary .desktop app-id.
  appId = appIdStem;
  # Upstream shell wrapper inside /opt.
  innerWrapper = fileStem;
  # macOS .app bundle name (inside the zip).
  darwinApp = darwinStem;
  # Upstream Exec= target in .desktop files (replaced with our wrapper).
  upstreamBin = "brave-${flavor}-stable";

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

      for exe in $out/opt/brave.com/${optName}/{${innerBinary},chrome_crashpad_handler}; do
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
          ln -s $out/opt/brave.com/${optName}/product_logo_''${icon}.png $out/share/icons/hicolor/''${icon}x''${icon}/apps/${fileBase}.png
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
    homepage = homepage;
    description =
      "Privacy-oriented browser for Desktop and Laptop computers"
      + lib.optionalString (flavor == "origin") " (Origin variant)";
    changelog =
      "https://github.com/brave/brave-browser/blob/master/${changelogFile}#"
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
      jefflabonte
      nasirhm
      buckley310
      rachalaraj
    ];
    platforms = builtins.attrNames archives;
    mainProgram = if flavor == "origin" then "brave-origin" else "brave";
  };
}
