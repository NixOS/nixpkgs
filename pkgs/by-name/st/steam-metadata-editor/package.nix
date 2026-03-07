{ lib
, stdenv
, python3
, fetchFromGitHub
, makeWrapper
, copyDesktopItems
, makeDesktopItem
}:

let
  python = python3.withPackages (ps: [ ps.tkinter ]);
in
stdenv.mkDerivation rec {
  pname = "steam-metadata-editor";
  version = "unstable-2025-03-07";

  src = fetchFromGitHub {
    owner = "tralph3";
    repo = "Steam-Metadata-Editor";
    rev = "5c6ec345417c48160ea9798d97643c6f0e82ba7d";
    hash = "sha256-+80NYqzTjWA7JZxHx0N1R96/B/XKtvnILhJ06JMwcX4=";
  };

  nativeBuildInputs = [ makeWrapper copyDesktopItems ];
  buildInputs = [ python ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/steam-metadata-editor
    cp -r src/* $out/lib/steam-metadata-editor/

    makeWrapper ${python}/bin/python3 $out/bin/steam-metadata-editor \
      --add-flags "$out/lib/steam-metadata-editor/main.py"

    install -Dm644 steam-metadata-editor.png \
      $out/share/pixmaps/steam-metadata-editor.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "steam-metadata-editor";
      exec = "steam-metadata-editor";
      icon = "steam-metadata-editor";
      desktopName = "Steam Metadata Editor";
      comment = "Edit the metadata of your Steam apps";
      categories = [ "Utility" ];
    })
  ];

  meta = with lib; {
    description = "GUI to edit the metadata of Steam apps locally";
    homepage = "https://github.com/tralph3/Steam-Metadata-Editor";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ honeyslatt ];
    platforms = platforms.linux;
    mainProgram = "steam-metadata-editor";
  };
}
