{ lib
, fetchFromGitLab
, python3Packages
, wrapGAppsHook4
, gst_all_1
, gobject-introspection
, yt-dlp
, libadwaita
, glib-networking
, nix-update-script
}:
python3Packages.buildPythonApplication rec {
  pname = "monophony";
  version = "2.15.0";
  pyproject = false;

  sourceRoot = "${src.name}/source";
  src = fetchFromGitLab {
    owner = "zehkira";
    repo = "monophony";
    rev = "v${version}";
    hash = "sha256-fC+XXOGBpG5pIQW1tCNtQaptBCyLM+YGgsZLjWrMoDA=";
  };

  pythonPath = with python3Packages; [
    mpris-server
    pygobject3
    ytmusicapi
  ];

  build-system = with python3Packages; [
    pip
    setuptools
    wheel
  ];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
    # needed for gstreamer https
    glib-networking
  ] ++ (with gst_all_1; [
    gst-plugins-base
    gst-plugins-good
    gstreamer
  ]);

  # Makefile only contains `install`
  dontBuild = true;

  installFlags = [ "prefix=$(out)" ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [yt-dlp]}"
      "''${gappsWrapperArgs[@]}"
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://gitlab.com/zehkira/monophony";
    description = "Linux app for streaming music from YouTube";
    longDescription = "Monophony is a free and open source Linux app for streaming music from YouTube. It has no ads and does not require an account.";
    license = licenses.agpl3Plus;
    mainProgram = "monophony";
    platforms = platforms.linux;
    maintainers = with maintainers; [ quadradical ];
  };
}
