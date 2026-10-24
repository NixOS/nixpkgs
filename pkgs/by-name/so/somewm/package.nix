{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  cairo,
  coreutils,
  dbus,
  gdk-pixbuf,
  glib,
  gobject-introspection,
  gtk3,
  harfbuzz,
  libdrm,
  libinput,
  librsvg,
  libxcb,
  libxcb-util,
  libxcb-wm,
  libxkbcommon,
  luajit,
  makeWrapper,
  meson,
  ninja,
  pam,
  pango,
  pkg-config,
  wayland,
  wayland-protocols,
  wayland-scanner,
  wlroots_0_20,
  wrapGAppsHook3,
  xwayland,
  extraGIPackages ? [ ],
  extraLuaPackages ? (_: [ ]),
}:
let
  luaEnv = luajit.withPackages (
    ps:
    with ps;
    [
      lgi
      ldbus
    ]
    ++ (extraLuaPackages ps)
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "somewm";
  version = "2.0.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "trip-zip";
    repo = "somewm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-E1992ZcMchbvwrcm5O7DNPYEoL7tugTxM8NSqQO5zPY=";
  };

  nativeBuildInputs = [
    gobject-introspection
    makeWrapper
    meson
    ninja
    pkg-config
    wayland-scanner
    wrapGAppsHook3
  ];

  buildInputs = [
    cairo
    dbus
    gdk-pixbuf
    glib
    gtk3
    harfbuzz
    libdrm
    libinput
    librsvg
    libxcb
    libxcb-util
    libxcb-wm
    libxkbcommon
    luajit
    luaEnv
    pam
    pango
    wayland
    wayland-protocols
    wlroots_0_20
    xwayland
  ];

  mesonFlags = [
    (lib.mesonEnable "systemd" false)
  ];

  dontWrapGApps = true;

  postFixup =
    let
      giPackages = [
        gdk-pixbuf
        glib.out
        gobject-introspection
        gtk3.out
        harfbuzz.out
        librsvg.out
        pango.out
      ]
      ++ extraGIPackages;
      giTypelibPath = lib.makeSearchPath "lib/girepository-1.0" giPackages;
      importEnvironment = "${lib.getExe' dbus "dbus-update-activation-environment"} --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=somewm; exec ${lib.getExe' coreutils "cat"} > /dev/null";
    in
    ''
      wrapProgram $out/bin/somewm \
        "''${gappsWrapperArgs[@]}" \
        --add-flag -s \
        --add-flag ${lib.escapeShellArg importEnvironment} \
        --prefix GI_TYPELIB_PATH : "${giTypelibPath}" \
        --prefix LUA_PATH : "${luaEnv}/share/lua/${luaEnv.luaversion}/?.lua;${luaEnv}/share/lua/${luaEnv.luaversion}/?/init.lua" \
        --prefix LUA_CPATH : "${luaEnv}/lib/lua/${luaEnv.luaversion}/?.so"
    '';

  passthru = {
    providedSessions = [ "somewm" ];
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Wayland compositor with an AwesomeWM-compatible Lua API";
    homepage = "https://somewm.org";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ yvnth ];
    platforms = lib.platforms.linux;
    mainProgram = "somewm";
  };
})
