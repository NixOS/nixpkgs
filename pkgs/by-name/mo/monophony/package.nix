{
  lib,
  fetchFromGitLab,
  python3Packages,
  wrapGAppsHook4,
  gobject-introspection,
  yt-dlp,
  nix-update-script,
}:
python3Packages.buildPythonApplication rec {
  pname = "monophony";
  version = "4.0.2";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "zehkira";
    repo = "monophony";
    tag = "v${version}";
    hash = "sha256-Q4au28I5BjE4GWm+SmK1XexiRqkuKfSwDRTkgziiAew=";
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
