{
  lib,
  python3Packages,
  fetchFromGitHub,
  wrapGAppsHook4,
  meson,
  ninja,
  pkg-config,
  blueprint-compiler,
  desktop-file-utils,
  libadwaita,
  gst_all_1,
  libsecret,
}:

python3Packages.buildPythonApplication {
  pname = "high-tide";
  version = "0-unstable-2025-02-25";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "Nokse22";
    repo = "high-tide";
    rev = "d0531d84e77bdc13872468e1748a6b1b4b0cb69f";
    hash = "sha256-ajxvP3d0x44tk7bccCNp3Q8VkJwaBU7VNYjgvkiAEh0=";
  };

  nativeBuildInputs = [
    wrapGAppsHook4
    meson
    ninja
    pkg-config
    blueprint-compiler
    desktop-file-utils
  ];

  buildInputs =
    [ libadwaita ]
    ++ (with gst_all_1; [
      gstreamer
      gst-plugins-base
      gst-plugins-good
      gst-plugins-ugly
      gst-plugins-bad
      libsecret
    ]);

  dependencies = with python3Packages; [
    pygobject3
    tidalapi
    requests
    mpd2
  ];

  dontWrapGApps = true;

  # XDG_CACHE_HOME needs to be set, or high-tide will save images to its working dir.
  makeWrapperArgs = [
    "--set-default XDG_CACHE_HOME '$HOME/.cache'"
    "--set-default XDG_DATA_HOME '$HOME/.local/share'"
    "\${gappsWrapperArgs[@]}"
  ];

  meta = {
    description = "Libadwaita TIDAL client for Linux";
    homepage = "https://github.com/Nokse22/high-tide";
    license = with lib.licenses; [ gpl3Plus ];
    mainProgram = "HighTide";
    maintainers = with lib.maintainers; [
      nyabinary
      griffi-gh
    ];
    platforms = lib.platforms.linux;
  };
}
