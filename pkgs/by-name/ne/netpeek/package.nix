{
  lib,
  python3Packages,
  fetchFromGitHub,
  meson,
  ninja,
  appstream,
  desktop-file-utils,
  gobject-introspection,
  wrapGAppsHook4,
  libadwaita,
  libportal-gtk4,
  nix-update-script,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "netpeek";
  version = "0.2.6";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "ZingyTomato";
    repo = "NetPeek";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SFY/bUUS4AOniOGjngH/fUHrYiq+dMWxHYvoSkhfnkA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    appstream
    desktop-file-utils
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
    libportal-gtk4
  ];

  dependencies = with python3Packages; [
    pygobject3
    ping3
    python-nmap
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern network scanner for GNOME";
    homepage = "https://github.com/ZingyTomato/NetPeek";
    changelog = "https://github.com/ZingyTomato/NetPeek/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ Cameo007 ];
    mainProgram = "netpeek";
    platforms = lib.platforms.linux;
  };
})
