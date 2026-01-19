{
  lib,
  python313Packages,
  fetchFromGitHub,
  wrapGAppsHook4,
  meson,
  ninja,
  pkg-config,
  blueprint-compiler,
  desktop-file-utils,
  libadwaita,
  glib-networking,
  gst_all_1,
  libsecret,
  libportal,
  alsa-utils,
  pipewire,
  nix-update-script,
}:

python313Packages.buildPythonApplication rec {
  pname = "high-tide";
  version = "1.1.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "Nokse22";
    repo = "high-tide";
    tag = "v${version}";
    hash = "sha256-AHdv2eazUnxgw5D4SlIzWm/wnC26zedwiAGT0OzjdZs=";
  };

  nativeBuildInputs = [
    wrapGAppsHook4
    meson
    ninja
    pkg-config
    blueprint-compiler
    desktop-file-utils
  ];

  buildInputs = [
    glib-networking
    libadwaita
    libportal
    pipewire # provides a gstreamer plugin for pipewiresink
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    libsecret
  ]);

  dependencies = [
    alsa-utils
  ]
  ++ (with python313Packages; [
    pygobject3
    tidalapi
    requests
    mpd2
    pypresence
  ]);

  dontWrapGApps = true;

  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Libadwaita TIDAL client for Linux";
    homepage = "https://github.com/Nokse22/high-tide";
    license = with lib.licenses; [ gpl3Plus ];
    mainProgram = "high-tide";
    maintainers = with lib.maintainers; [
      drafolin
      nilathedragon
      nyabinary
      griffi-gh
    ];
    platforms = lib.platforms.linux;
  };
}
