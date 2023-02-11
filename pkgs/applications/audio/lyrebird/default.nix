{ python3Packages
, lib
, fetchFromGitHub
, makeDesktopItem
, wrapGAppsHook
, gtk3
, gobject-introspection
, sox
, pulseaudio
}:
let
  desktopItem = makeDesktopItem {
    name = "lyrebird";
    exec = "lyrebird";
    icon = "${placeholder "out"}/share/lyrebird/icon.png";
    desktopName = "Lyrebird";
    genericName = "Voice Changer";
    categories = [ "AudioVideo" "Audio" ];
  };
in
python3Packages.buildPythonApplication rec {
  pname = "lyrebird";
  version = "1.1.0";

  format = "other";
  doCheck = false;

  src = fetchFromGitHub {
    owner = "chxrlt";
    repo = "lyrebird";
    rev = "v${version}";
    sha256 = "0wmnww2wi8bb9m8jgc18n04gjia8pf9klmvij0w98xz11l6kxb13";
  };

  propagatedBuildInputs = with python3Packages; [ toml pygobject3 ];

  nativeBuildInputs = [ wrapGAppsHook ];

  buildInputs = [ gtk3 gobject-introspection sox ];

  dontWrapGApps = true;
  makeWrapperArgs = [
    "--prefix 'PATH' ':' '${lib.makeBinPath [ sox pulseaudio ]}'"
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
    homepage = "https://github.com/chxrlt/lyrebird";
    license = licenses.mit;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.linux;
  };
}
