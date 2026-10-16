{
  python3Packages,
  lib,
  fetchFromGitHub,
  makeDesktopItem,
  wrapGAppsHook3,
  gtk3,
  gobject-introspection,
  copyDesktopItems,
  sox,
  pulseaudio,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "lyrebird";
  version = "1.2.0";

  pyproject = false;
  doCheck = false;

  src = fetchFromGitHub {
    owner = "lyrebird-voice-changer";
    repo = "lyrebird";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-VIYcOxvSpzRvJMzEv2i5b7t0WMF7aQxB4Y1jfvuZN/Y=";
  };

  propagatedBuildInputs = with python3Packages; [
    toml
    pygobject3
  ];

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
    copyDesktopItems
  ];

  buildInputs = [
    gtk3
    sox
  ];

  dontWrapGApps = true;
  makeWrapperArgs = [
    "--prefix 'PATH' ':' '${
      lib.makeBinPath [
        sox
        pulseaudio
      ]
    }'"
    "--prefix 'PYTHONPATH' ':' '${placeholder "out"}/share/lyrebird'"
    "--chdir '${placeholder "out"}/share/lyrebird'"
    ''"''${gappsWrapperArgs[@]}"''
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/{applications,lyrebird}}
    cp -at $out/share/lyrebird/ app icon.png
    install -Dm755 app.py $out/bin/lyrebird

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "lyrebird";
      exec = "lyrebird";
      icon = "${placeholder "out"}/share/lyrebird/icon.png";
      desktopName = "Lyrebird";
      genericName = "Voice Changer";
      categories = [
        "AudioVideo"
        "Audio"
      ];
    })
  ];

  meta = {
    description = "Simple and powerful voice changer for Linux, written in GTK 3";
    mainProgram = "lyrebird";
    homepage = "https://github.com/lyrebird-voice-changer/lyrebird";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.linux;
  };
})
