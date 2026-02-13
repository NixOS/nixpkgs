{
  fetchFromGitHub,
  lib,
  nix-update-script,
  stdenvNoCC,

  # build
  qt6,
  quickshell,

  # runtime deps
  brightnessctl,
  cava,
  cliphist,
  ddcutil,
  wlsunset,
  wl-clipboard,
  imagemagick,
  wget,
  gpu-screen-recorder,
  python3,
  wayland-scanner,

  # calendar support
  evolution-data-server,
  libical,
  glib,
  libsoup_3,
  json-glib,
  gobject-introspection,

  brightnessctlSupport ? true,
  cavaSupport ? true,
  cliphistSupport ? true,
  ddcutilSupport ? true,
  wlsunsetSupport ? true,
  wl-clipboardSupport ? true,
  imagemagickSupport ? true,
  calendarSupport ? false,
  # gpu-screen-recorder support was moved to an optional plugin in v4.0.0
  gpuScreenRecorderSupport ? false,
}:
let
  runtimeDeps = [
    wget
    (python3.withPackages (pp: lib.optional calendarSupport pp.pygobject3))
  ]
  ++ lib.optional brightnessctlSupport brightnessctl
  ++ lib.optional cavaSupport cava
  ++ lib.optional cliphistSupport cliphist
  ++ lib.optional ddcutilSupport ddcutil
  ++ lib.optional wlsunsetSupport wlsunset
  ++ lib.optional wl-clipboardSupport wl-clipboard
  ++ lib.optional imagemagickSupport imagemagick
  ++ lib.optional gpuScreenRecorderSupport gpu-screen-recorder;

  giTypelibPath = lib.makeSearchPath "lib/girepository-1.0" [
    evolution-data-server
    libical
    glib.out
    libsoup_3
    json-glib
    gobject-introspection
  ];
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "noctalia-shell";
  version = "4.4.3";

  src = fetchFromGitHub {
    owner = "noctalia-dev";
    repo = "noctalia-shell";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5HqCE5qfW6ItA+ZeFGfTT7/+12QYp/1j93EPdn+nlK0=";
  };

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtmultimedia
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/noctalia-shell $out/bin
    ln -s ${quickshell}/bin/qs $out/bin/noctalia-shell

    cp -R \
      Assets Commons CREDITS.md Helpers Modules Services Shaders Scripts Widgets shell.qml \
      $out/share/noctalia-shell

    rm -R $out/share/noctalia-shell/Assets/Screenshots

    runHook postInstall
  '';

  preFixup = ''
    qtWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath runtimeDeps}
      --prefix XDG_DATA_DIRS : ${wayland-scanner}/share
      --add-flags "-p $out/share/noctalia-shell"
      ${lib.optionalString calendarSupport "--prefix GI_TYPELIB_PATH : ${giTypelibPath}"}
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/noctalia-dev/noctalia-shell/releases/tag/v${finalAttrs.version}";
    description = "Sleek and minimal desktop shell thoughtfully crafted for Wayland, built with Quickshell";
    homepage = "https://github.com/noctalia-dev/noctalia-shell";
    license = lib.licenses.mit;
    mainProgram = "noctalia-shell";
    maintainers = with lib.maintainers; [ spacedentist ];
    platforms = quickshell.meta.platforms;
  };
})
