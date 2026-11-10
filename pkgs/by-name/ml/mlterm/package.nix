{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  autoconf,
  makeDesktopItem,
  nixosTests,
  vte,
  harfbuzz, # can be replaced with libotf
  fribidi,
  m17n_lib,
  libssh2, # build-in ssh
  fcitx5,
  fcitx5-gtk,
  ibus,
  uim, # IME
  wrapGAppsHook3, # color picker in mlconfig
  gdk-pixbuf,
  gtk3,
  gtk ? gtk3,
  # List of gui libraries to use. According to `./configure --help` ran on
  # release 3.9.3, options are: (xlib|win32|fb|quartz|console|wayland|sdl2|beos)
  enableGuis ? {
    xlib = enableX11;
    # From some reason, upstream's ./configure script disables compilation of the
    # external tool `mlconfig` if `enableGuis.fb == true`. This behavior is not
    # documentd in `./configure --help`, and it is reported here:
    # https://github.com/arakiken/mlterm/issues/73
    fb = false;
    quartz = stdenv.hostPlatform.isDarwin;
    wayland = stdenv.hostPlatform.isLinux;
    sdl2 = true;
  },
  libxkbcommon,
  wayland, # for the "wayland" --with-gui option
  SDL2, # for the "sdl" --with-gui option
  # List of typing engines, the default list enables compiling all of the
  # available ones, as recorded on release 3.9.3
  enableTypeEngines ? {
    xcore = false; # Considered legacy
    xft = enableX11;
    cairo = true;
  },
  libx11,
  libxft,
  cairo,
  # List of external tools to create, this default list includes all default
  # tools, as recorded on release 3.9.3.
  enableTools ? {
    mlclient = true;
    mlconfig = true;
    mlcc = true;
    mlterm-menu = true;
    # Note that according to upstream's ./configure script, to disable
    # mlimgloader you have to disable _all_ tools. See:
    # https://github.com/arakiken/mlterm/issues/69
    mlimgloader = true;
    registobmp = true;
    mlfc = true;
  },
  # Whether to enable the X window system
  enableX11 ? stdenv.hostPlatform.isLinux,
  # Most of the input methods and other build features are enabled by default,
  # the following attribute set can be used to disable some of them. It's parsed
  # when we set `configureFlags`. If you find other configure Flags that require
  # dependencies, it'd be nice to make that contribution here.
  enableFeatures ? {
    uim = !stdenv.hostPlatform.isDarwin;
    ibus = !stdenv.hostPlatform.isDarwin;
    fcitx = !stdenv.hostPlatform.isDarwin;
    m17n = !stdenv.hostPlatform.isDarwin;
    ssh2 = true;
    bidi = true;
    # Open Type layout support, (substituting glyphs with opentype fonts)
    otl = true;
  },
  # Configure the Exec directive in the generated .desktop file
  desktopBinary ? (
    if enableGuis.xlib then
      "mlterm"
    else if enableGuis.wayland then
      "mlterm-wl"
    else if enableGuis.sdl2 then
      "mlterm-sdl2"
    else
      throw "mlterm: couldn't figure out what desktopBinary to use."
  ),
}:

let
  # Returns a --with-feature=<comma separated string list of all `true`
  # attributes>, or `--without-feature` if all attributes are false or don't
  # exist. Used later in configureFlags
  withFeaturesList =
    featureName: attrset:
    let
      commaSepList = lib.concatStringsSep "," (builtins.attrNames (lib.filterAttrs (n: v: v) attrset));
    in
    lib.withFeatureAs (commaSepList != "") featureName commaSepList;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mlterm";
  version = "3.9.4";

  src = fetchFromGitHub {
    owner = "arakiken";
    repo = "mlterm";
    tag = finalAttrs.version;
    sha256 = "sha256-YogapVTmW4HAyVgvhR4ZvW4Q6v0kGiW11CCxN6SpPCY=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/arakiken/mlterm/commit/819366f9c3c015d1be501d626ca954ce3ce38a60.patch";
      hash = "sha256-xI0CzXN3gfXZXrL1/tFgQDtpY5hnzGLPruidOuMrbPQ=";
      excludes = [
        "ChangeLog"
      ];
    })
  ];

  nativeBuildInputs = [
    pkg-config
    autoconf
  ]
  ++ lib.optionals enableTools.mlconfig [
    wrapGAppsHook3
  ];
  buildInputs = [
    gtk
    vte
    gdk-pixbuf
  ]
  ++ lib.optionals enableTypeEngines.xcore [
    libx11
  ]
  ++ lib.optionals enableTypeEngines.xft [
    libxft
  ]
  ++ lib.optionals enableTypeEngines.cairo [
    cairo
  ]
  ++ lib.optionals enableGuis.wayland [
    libxkbcommon
    wayland
  ]
  ++ lib.optionals enableGuis.sdl2 [
    SDL2
  ]
  ++ lib.optionals enableFeatures.otl [
    harfbuzz
  ]
  ++ lib.optionals enableFeatures.bidi [
    fribidi
  ]
  ++ lib.optionals enableFeatures.ssh2 [
    libssh2
  ]
  ++ lib.optionals enableFeatures.m17n [
    m17n_lib
  ]
  ++ lib.optionals enableFeatures.fcitx [
    fcitx5
    fcitx5-gtk
  ]
  ++ lib.optionals enableFeatures.ibus [
    ibus
  ]
  ++ lib.optionals enableFeatures.uim [
    uim
  ];

  env = {
    NIX_CFLAGS_COMPILE =
      # GCC15 defaults to C23 which is stricter about prototypes
      # There are upstream fixes, but they are not in 3.9.4 release
      lib.optionalString stdenv.cc.isGNU " -std=c17 ";
  };

  configureFlags = [
    (withFeaturesList "type-engines" enableTypeEngines)
    (withFeaturesList "tools" enableTools)
    (withFeaturesList "gui" enableGuis)
    (lib.withFeature enableX11 "x")
  ]
  ++ lib.optionals (gtk != null) [
    "--with-gtk=${lib.versions.major gtk.version}.0"
  ]
  ++ (lib.mapAttrsToList (n: v: lib.enableFeature v n) enableFeatures)
  ++ [
  ];

  enableParallelBuilding = true;

  postInstall = ''
    install -D contrib/icon/mlterm-icon.svg "$out/share/icons/hicolor/scalable/apps/mlterm.svg"
    install -D contrib/icon/mlterm-icon-gnome2.png "$out/share/icons/hicolor/48x48/apps/mlterm.png"
    install -D -t $out/share/applications $desktopItem/share/applications/*
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications/
    cp -a cocoa/mlterm.app $out/Applications/
    install $out/bin/mlterm -Dt $out/Applications/mlterm.app/Contents/MacOS/
  '';

  desktopItem = makeDesktopItem {
    name = "mlterm";
    exec = "${desktopBinary} %U";
    icon = "mlterm";
    type = "Application";
    comment = "Multi Lingual TERMinal emulator";
    desktopName = "mlterm";
    genericName = "Terminal emulator";
    categories = [
      "System"
      "TerminalEmulator"
    ];
    startupNotify = false;
  };

  passthru = {
    tests.test = nixosTests.terminal-emulators.mlterm;
    inherit
      enableTypeEngines
      enableTools
      enableGuis
      enableFeatures
      ;
  };

  meta = {
    description = "Multi Lingual TERMinal emulator";
    homepage = "https://mlterm.sourceforge.net/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      ramkromberg
      atemu
      doronbehar
    ];
    platforms = lib.platforms.all;
    mainProgram = desktopBinary;
  };
})
