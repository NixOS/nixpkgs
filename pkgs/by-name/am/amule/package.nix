{
  monolithic ? true, # build monolithic amule
  enableDaemon ? false, # build amule daemon
  httpServer ? false, # build web interface for the daemon
  client ? false, # build amule remote gui
  textClient ? false, # build amule remote command line client
  mainProgram ? "amule",
  fetchFromGitHub,
  stdenv,
  lib,
  cmake,
  zlib,
  wxwidgets_3_2,
  curl,
  cryptopp,
  libupnp,
  boost,
  gettext,
  glib,
  libintl,
  gtk3,
  libayatana-appindicator,
  libsysprof-capture,
  libmaxminddb,
  libpng,
  pkg-config,
  readline,
  nix-update-script,
  writeShellScript,
  xcbuild,
  libx11,
}:

let
  # MacOS's plutil lives under /usr/bin, which the build sandbox blocks
  # so we use `xcbuild`'s pure reimplementation instead.
  # CMake generates the bundle plist read-only, so we make i
  # writable before plutil rewrites it in place.
  plutil = writeShellScript "amule-plutil" ''
    for plist; do :; done
    chmod u+w "$plist"
    exec ${lib.getExe' xcbuild "plutil"} "$@"
  '';
in

# daemon, clients and web interface are not built monolithic
assert monolithic || (!monolithic && (enableDaemon || client || textClient || httpServer));

stdenv.mkDerivation (finalAttrs: {
  pname =
    "amule"
    + lib.optionalString httpServer "-web"
    + lib.optionalString enableDaemon "-daemon"
    + lib.optionalString client "-gui"
    + lib.optionalString textClient "-cmd";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "amule-org";
    repo = "amule";
    tag = finalAttrs.version;
    hash = "sha256-zLd8mt+dYEilGcFn3qspZv5EkZ4TmBbKgvgcuSvswFk=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gettext
    pkg-config
  ];

  postPatch =
    lib.optionalString (stdenv.hostPlatform.isDarwin && (monolithic || client)) ''
      substituteInPlace src/CMakeLists.txt \
        --replace-fail "/usr/bin/plutil" "${plutil}"
    ''
    # The __WXMAC__ branch casts to the pre-libedit-3.0 `Function` typedef,
    # which neither the modern SDK libedit headers nor GNU readline 8.3
    # provide; both declare rl_completion_entry_function with the typedef
    # used here.
    + lib.optionalString (stdenv.hostPlatform.isDarwin && (textClient || httpServer)) ''
      substituteInPlace src/ExternalConnector.cpp \
        --replace-fail "(Function *)&command_completion" "(rl_compentry_func_t *)&command_completion"
    '';

  buildInputs = [
    zlib
    wxwidgets_3_2
    cryptopp.dev
    libupnp
    boost
  ]
  # the GUI and daemon bind the Wayland app_id/X11 WM_CLASS via g_set_prgname();
  # libsysprof-capture satisfies glib-2.0.pc's Requires.private so the
  # pkg-config checks resolve cleanly
  ++ lib.optionals (stdenv.hostPlatform.isLinux && (monolithic || enableDaemon || client)) [
    glib
    libsysprof-capture
  ]
  # CURLOPT tuning (NOSIGNAL/CONNECTTIMEOUT) on wxWebRequest's curl backend
  ++ lib.optional stdenv.hostPlatform.isLinux curl
  # StatusNotifierItem tray icon; without it aMule falls back to the legacy
  # GtkStatusIcon, invisible on modern GNOME/wlroots. gtk3 brings the
  # gtk+-3.0.pc that ayatana-appindicator3-0.1.pc requires
  ++ lib.optionals (stdenv.hostPlatform.isLinux && monolithic) [
    gtk3
    libayatana-appindicator
  ]
  ++ lib.optional httpServer libpng
  ++ lib.optional (monolithic || enableDaemon || client) libmaxminddb
  # gettext runtime for NLS; on glibc libintl is part of libc
  ++ lib.optional (!stdenv.hostPlatform.isGnu) libintl
  # line editing in the interactive consoles of amulecmd and amuleweb
  ++ lib.optional (textClient || httpServer) readline
  ++ lib.optional client libx11;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_MONOLITHIC" monolithic)
    (lib.cmakeBool "BUILD_DAEMON" enableDaemon)
    (lib.cmakeBool "BUILD_REMOTEGUI" client)
    (lib.cmakeBool "BUILD_AMULECMD" textClient)
    (lib.cmakeBool "BUILD_WEBSERVER" httpServer)
    # with strictDeps FindwxWidgets cannot find wx-config in PATH
    # the script runs on the build machine even when wxwidgets is a host dependency
    (lib.cmakeFeature "wxWidgets_CONFIG_EXECUTABLE" (
      lib.getExe' (lib.getDev wxwidgets_3_2) "wx-config"
    ))
  ];

  # On darwin the GUIs are installed as app bundles in $out
  # move them to $out/Applications and expose the inner binaries in $out/bin
  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    for app in "$out"/*.app; do
      [ -e "$app" ] || continue
      mkdir -p "$out/Applications" "$out/bin"
      mv "$app" "$out/Applications/"
      name=$(basename "$app" .app)
      ln -s "$out/Applications/$name.app/Contents/MacOS/$name" \
        "$out/bin/$(echo "$name" | tr '[:upper:]' '[:lower:]')"
    done
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Peer-to-peer client for the eD2K and Kademlia networks";
    longDescription = ''
      aMule is an eMule-like client for the eD2k and Kademlia
      networks, supporting multiple platforms.  Currently aMule
      (officially) supports a wide variety of platforms and operating
      systems, being compatible with more than 60 different
      hardware+OS configurations.  aMule is entirely free, its
      sourcecode released under the GPL just like eMule, and includes
      no adware or spyware as is often found in proprietary P2P
      applications.
    '';
    homepage = "https://amule-org.github.io/";
    changelog = "https://github.com/amule-org/amule/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ aciceri ];
    inherit mainProgram;
    platforms = lib.platforms.unix;
  };
})
