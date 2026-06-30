{
  lib,
  python3Packages,
  copyDesktopItems,
  fetchFromGitHub,
  gobject-introspection,
  makeDesktopItem,
  wrapGAppsHook3,
}:

python3Packages.buildPythonApplication rec {
  pname = "jellyfin-mpv-shim";
  version = "2.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-mpv-shim";
    tag = "v${version}";
    hash = "sha256-x9ay4ucWBGRSTJxSJS6hkGTPAtlktOEBXUsutJTo2Fk=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    wrapGAppsHook3
    gobject-introspection
  ];

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    jellyfin-apiclient-python
    mpv
    python-mpv-jsonipc
    requests

    # gui + mirror dependencies
    pillow
    pystray

    # discord rich presence dependency
    pypresence
  ];

  preCheck = ''
    export HOME=$TMPDIR

    # remove jellyfin_mpv_shim/win_utils.py:
    #   ModuleNotFoundError: No module named 'win32gui'
    rm jellyfin_mpv_shim/win_utils.py
  '';

  postPatch = ''
    substituteInPlace jellyfin_mpv_shim/conf.py \
      --replace-fail "check_updates: bool = True" "check_updates: bool = False" \
      --replace-fail "notify_updates: bool = True" "notify_updates: bool = False"
    # python-mpv renamed to mpv with 1.0.4
    substituteInPlace pyproject.toml \
      --replace-fail "python-mpv" "mpv" \
      --replace-fail "mpv-jsonipc" "python_mpv_jsonipc"
  '';

  # Install all the icons for the desktop item
  postInstall = ''
    for s in 16 32 48 64 128 256; do
      mkdir -p $out/share/icons/hicolor/''${s}x''${s}/apps
      ln -s $out/${python3Packages.python.sitePackages}/jellyfin_mpv_shim/integration/jellyfin-''${s}.png \
        $out/share/icons/hicolor/''${s}x''${s}/apps/jellyfin-mpv-shim.png
    done
  '';

  # needed for pystray to access appindicator using GI
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';
  dontWrapGApps = true;

  pythonImportsCheck = [ "jellyfin_mpv_shim" ];

  desktopItems = [
    (makeDesktopItem {
      name = "jellyfin-mpv-shim";
      exec = "jellyfin-mpv-shim";
      icon = "jellyfin-mpv-shim";
      desktopName = "Jellyfin MPV Shim";
      categories = [
        "Video"
        "AudioVideo"
        "TV"
        "Player"
      ];
    })
  ];

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
    changelog = "https://github.com/jellyfin/jellyfin-mpv-shim/releases/tag/v${version}";
    license = with lib.licenses; [
      # jellyfin-mpv-shim
      gpl3Only
      mit

      # shader-pack licenses (github:iwalton3/default-shader-pack)
      # KrigBilateral, SSimDownscaler, NNEDI3
      gpl3Plus
      # Anime4K, FSRCNNX
      mit
      # Static Grain
      unlicense
    ];
    maintainers = with lib.maintainers; [ jojosch ];
    mainProgram = "jellyfin-mpv-shim";
  };
}
