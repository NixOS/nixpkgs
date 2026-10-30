{
  lib,
  python3Packages,
  fetchPypi,
  gobject-introspection,
  mpv,
  wrapGAppsHook3,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "jellyfin-mpv-shim";
  version = "3.3.0";
  pyproject = true;

  # contains shaderpacks
  src = fetchPypi {
    pname = "jellyfin_mpv_shim";
    inherit (finalAttrs) version;
    hash = "sha256-GAdTaLM+Lb0RKcAzdlU3c9aEttv9533M7dyvQAbKezk=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ];

  build-system = with python3Packages; [ setuptools ];

  # only pinned for its CA bundle
  pythonRemoveDeps = [ "certifi" ];

  dependencies = with python3Packages; [
    jellyfin-apiclient-python
    python3Packages.mpv
    pillow
    pygobject3
    python-mpv-jsonipc
    requests

    # systray dependency
    pystray

    # discord rich presence dependency
    pypresence
  ];

  postPatch = ''
    substituteInPlace jellyfin_mpv_shim/conf.py \
      --replace-fail "check_updates: bool = True" "check_updates: bool = False" \
      --replace-fail 'notify_updates: str = "default"' 'notify_updates: str = "disabled"'
    # python-mpv renamed to mpv with 1.0.3
    substituteInPlace pyproject.toml \
      --replace-fail '"python-mpv>=' '"mpv>='
  '';

  postInstall = ''
    install -Dm644 -t "$out"/share/applications jellyfin_mpv_shim/integration/com.github.iwalton3.jellyfin-mpv-shim.desktop
    install -Dm644 -t "$out"/share/metainfo jellyfin_mpv_shim/integration/com.github.iwalton3.jellyfin-mpv-shim.appdata.xml
    for s in 16 32 48 64 128 256; do
      install -Dm644 jellyfin_mpv_shim/integration/jellyfin-"$s".png \
        "$out"/share/icons/hicolor/"$s"x"$s"/apps/com.github.iwalton3.jellyfin-mpv-shim.png
    done
  '';

  makeWrapperArgs = [
    "--suffix"
    "PATH"
    ":"
    (lib.makeBinPath [ mpv ])
  ];

  # needed for pystray to access appindicator using GI
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';
  dontWrapGApps = true;

  pythonImportsCheck = [ "jellyfin_mpv_shim" ];

  meta = {
    homepage = "https://github.com/jellyfin/jellyfin-mpv-shim";
    description = "Allows casting of videos to MPV via the jellyfin mobile and web app";
    longDescription = ''
      Jellyfin MPV Shim is a client for the Jellyfin media server which plays media in the
      MPV media player. The application runs in the background and opens MPV only
      when media is cast to the player. The player supports most file formats, allowing you
      to prevent needless transcoding of your media files on the server. The player also has
      advanced features, such as bulk subtitle updates and launching commands on events.
    '';
    changelog = "https://github.com/jellyfin/jellyfin-mpv-shim/releases/tag/v${finalAttrs.version}";
    license =
      with lib.licenses;
      AND [
        # jellyfin-mpv-shim
        gpl3Plus
        # jellyfin-mpv-shim, and the Anime4K, NVIDIA Image Scaling, AMD FSR, AMD CAS and ArtCNN shaders
        mit
        # KrigBilateral, SSimDownscaler, NNEDI3 and FSRCNNX shaders
        lgpl3Plus
        # Static Grain and Anime4K AutoDownscalePre shaders
        unlicense
      ];
    maintainers = with lib.maintainers; [
      connor-grady
      jojosch
    ];
    mainProgram = "jellyfin-mpv-shim";
    platforms = lib.platforms.linux;
  };
})
