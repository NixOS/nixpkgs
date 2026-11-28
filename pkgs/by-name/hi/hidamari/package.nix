{
  lib,
  adwaita-icon-theme,
  desktop-file-utils,
  fetchFromGitHub,
  ffmpeg,
  gnome-desktop,
  gobject-introspection,
  libappindicator-gtk3,
  libwnck,
  mesa-demos,
  meson,
  ninja,
  nix-update-script,
  python3Packages,
  vdpauinfo,
  webkitgtk_4_1,
  wrapGAppsHook3,
  xdg-user-dirs,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "hidamari";
  version = "3.6";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jeffshee";
    repo = "hidamari";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4hpznrnV1Mc2GVh2Oo4y6/M++YtEO3snHkfzP2kog50=";
  };

  pyproject = false;

  nativeBuildInputs = [
    meson
    ninja
    wrapGAppsHook3
    gobject-introspection
    desktop-file-utils
  ];

  buildInputs = [
    ffmpeg
    gnome-desktop
    libappindicator-gtk3
    libwnck
    mesa-demos
    vdpauinfo
    webkitgtk_4_1
    xdg-user-dirs
  ];

  dependencies = with python3Packages; [
    pillow
    pydbus
    pygobject3
    python-vlc
    requests
    setproctitle
    yt-dlp
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${adwaita-icon-theme}/share"
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Video wallpaper for Linux";
    homepage = "https://github.com/jeffshee/hidamari";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ PerchunPak ];
    mainProgram = "hidamari";
    platforms = lib.platforms.linux;
  };
})
