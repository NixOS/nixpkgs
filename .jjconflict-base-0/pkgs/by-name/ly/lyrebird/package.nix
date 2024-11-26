{
  python3Packages,
  lib,
  fetchFromGitHub,
  makeDesktopItem,
  wrapGAppsHook3,
  gtk3,
  gobject-introspection,
  sox,
  pulseaudio,
}:
let
  desktopItem = makeDesktopItem {
    name = "lyrebird";
    exec = "lyrebird";
    icon = "${placeholder "out"}/share/lyrebird/icon.png";
    desktopName = "Lyrebird";
    genericName = "Voice Changer";
    categories = [
      "AudioVideo"
      "Audio"
    ];
  };
in
python3Packages.buildPythonApplication rec {
  pname = "lyrebird";
  version = "1.2.0";

  format = "other";
  doCheck = false;

  src = fetchFromGitHub {
    owner = "chxrlt";
    repo = "lyrebird";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-VIYcOxvSpzRvJMzEv2i5b7t0WMF7aQxB4Y1jfvuZN/Y=";
  };

  propagatedBuildInputs = with python3Packages; [
    toml
    pygobject3
  ];

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
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
    mkdir -p $out/{bin,share/{applications,lyrebird}}
    cp -at $out/share/lyrebird/ app icon.png
    cp -at $out/share/applications/ ${desktopItem}
    install -Dm755 app.py $out/bin/lyrebird
  '';

  meta = with lib; {
    description = "Simple and powerful voice changer for Linux, written in GTK 3";
    mainProgram = "lyrebird";
    homepage = "https://github.com/chxrlt/lyrebird";
    license = licenses.mit;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.linux;
  };
}
