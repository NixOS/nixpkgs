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
  version = "0-unstable-2025-05-01";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "Nokse22";
    repo = "high-tide";
    rev = "6278ff9471b7481cf0291ab2a9f6d06322506dfc";
    hash = "sha256-4pVRVXEwz0ngjS1Vpt/o00lLYsZ6SvTCk4ivyGoQ4lQ=";
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

  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

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
