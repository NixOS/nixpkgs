{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  qt6,
  copyDesktopItems,
  makeDesktopItem,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "kennethsible-jellyfin-rpc";
  version = "1.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kennethsible";
    repo = "jellyfin-rpc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BHYROPejvLouxFbUluO4R2G/Ja6igd4uMWNf1FTLKLw=";
  };

  build-system = with python3Packages; [ hatchling ];

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ copyDesktopItems ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ qt6.qtwayland ];

  dependencies = with python3Packages; [
    aiohttp
    aiohttp-client-cache
    certifi
    langcodes
    language-data
    pypresence
    pyside6
    requests
  ];

  # Upstream asks for a newer version than what we have
  pythonRelaxDeps = [
    "aiohttp"
    "aiohttp-client-cache"
    "pypresence"
  ];

  # Qt wrapping is done by the Python wrapper instead
  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'hatchling>=1.32.0' 'hatchling'
  '';

  postInstall = ''
    # Program expects its images next to the Python files
    install -Dm644 -t $out/${python3Packages.python.sitePackages}/jellyfin_rpc \
      images/icon.png \
      images/icon.ico \
      images/icon_menubar.png \
      images/check_white.svg \
      images/check_gray.svg

    # Program only starts the GUI from its frozen bundle, so call the GUI entry point directly
    cat > $out/bin/jellyfin-rpc-gui <<'EOF'
    #!${python3Packages.python.interpreter}
    from jellyfin_rpc.app import main

    main()
    EOF
    chmod +x $out/bin/jellyfin-rpc-gui

    install -Dm644 images/icon.png $out/share/icons/hicolor/1024x1024/apps/jellyfin-rpc.png
  '';

  desktopItems = lib.optionals stdenv.hostPlatform.isLinux [
    (makeDesktopItem {
      name = "jellyfin-rpc";
      exec = "jellyfin-rpc-gui";
      icon = "jellyfin-rpc";
      comment = "Discord Rich Presence client for Jellyfin";
      desktopName = "Jellyfin RPC";
      categories = [
        "Utility"
        "Network"
      ];
    })
  ];

  pythonImportsCheck = [ "jellyfin_rpc" ];

  meta = {
    description = "Discord RPC for Jellyfin that displays what you're watching or listening to";
    homepage = "https://github.com/kennethsible/jellyfin-rpc";
    changelog = "https://github.com/kennethsible/jellyfin-rpc/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "jellyfin-rpc";
    maintainers = with lib.maintainers; [ _2hexed ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
