{
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  python3Packages,

  adwaita-icon-theme,
  desktop-file-utils,
  ffmpeg,
  gnome-desktop,
  gobject-introspection,
  libappindicator-gtk3,
  libwnck,
  mesa-demos,
  vdpauinfo,
  webkitgtk_4_1,
  wrapGAppsHook3,
  xdg-user-dirs,
}:
let
  version = "3.6";
in
python3Packages.buildPythonApplication {
  pname = "hidamari";
  inherit version;

  src = fetchFromGitHub {
    owner = "jeffshee";
    repo = "hidamari";
    tag = "v${version}";
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
    gnome-desktop
    libappindicator-gtk3
    libwnck
    vdpauinfo
    webkitgtk_4_1
  ];

  dependencies = [
    ffmpeg
    xdg-user-dirs
    mesa-demos
  ]
  ++ (with python3Packages; [
    pillow
    pydbus
    pygobject3
    python-vlc
    requests
    setproctitle
    yt-dlp
  ]);

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${adwaita-icon-theme}/share"
    )
  '';

  meta = {
    description = "Video wallpaper for Linux";
    homepage = "https://github.com/jeffshee/hidamari";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ PerchunPak ];
    mainProgram = "hidamari";
    platforms = lib.platforms.linux;
  };
}
