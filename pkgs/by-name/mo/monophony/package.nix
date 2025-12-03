{
  lib,
  fetchFromGitLab,
  python3Packages,
  wrapGAppsHook4,
  gobject-introspection,
  yt-dlp,
  gst_all_1,
  libadwaita,
  glib-networking,
  nix-update-script,
}:
python3Packages.buildPythonApplication rec {
  pname = "monophony";
  version = "4.1.2";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "zehkira";
    repo = "monophony";
    tag = "v${version}";
    hash = "sha256-nX4GXuQd+WzaRGBtsWduUpwtA3DGjpRkcxPmoEj7FIA=";
  };

  sourceRoot = "${src.name}/source";

  dependencies = with python3Packages; [
    mprisify
    requests
    ytmusicapi
  ];

  build-system = with python3Packages; [
    setuptools
    pip
  ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
    # needed for gstreamer https
    glib-networking
  ]
  ++ (with gst_all_1; [
    gst-plugins-base
    gst-plugins-good
    gstreamer
  ]);

  postInstall = "make install prefix=$out";

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ yt-dlp ]}"
      "''${gappsWrapperArgs[@]}"
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Linux app for streaming music from YouTube";
    longDescription = "Monophony allows you to stream and download music from YouTube Music without ads, as well as create and import playlists without signing in.";
    homepage = "https://gitlab.com/zehkira/monophony";
    license = lib.licenses.bsd0;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ quadradical ];
    mainProgram = "monophony";
  };
}
