{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  jdk,
  libsecret,
  glib,
  webkitgtk_4_1,
  wrapGAppsHook3,
  _7zz,
  nixosTests,
  copyDesktopItems,
  makeDesktopItem,
}:

stdenv.mkDerivation rec {
  pname = "Archi";
  version = "5.6.0";

  src =
    {
      "x86_64-linux" = fetchurl {
        url = "https://www.archimatetool.com/downloads/archi/${version}/Archi-Linux64-${version}.tgz";
        hash = "sha256-zPgsRfbhN22Sph/5AvP7y2uHdgy1cZRcsm+O1dVLNHc=";
      };
      "x86_64-darwin" = fetchurl {
        url = "https://www.archimatetool.com/downloads/archi/${version}/Archi-Mac-${version}.dmg";
        hash = "sha256-NZWMQzLsPcJ7cZoYFUxXxLIu7yCIHE5pw9+UqjtG7Cc=";
      };
      "aarch64-darwin" = fetchurl {
        url = "https://www.archimatetool.com/downloads/archi/${version}/Archi-Mac-Silicon-${version}.dmg";
        hash = "sha256-a80QyJT+mizT4bxhJ/1rXnQGbq0Zxwmqb74n2QH4H3I=";
      };
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  buildInputs = [
    libsecret
  ];

  nativeBuildInputs = [
    makeWrapper
    wrapGAppsHook3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    _7zz
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
    copyDesktopItems
  ];

  sourceRoot = if stdenv.hostPlatform.isDarwin then "." else null;

  installPhase =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      ''
        runHook preInstall

        mkdir -p $out/bin $out/libexec
        for f in configuration features p2 plugins Archi.ini; do
          cp -r $f $out/libexec
        done

        install -D -m755 Archi $out/libexec/Archi
        makeWrapper $out/libexec/Archi $out/bin/Archi \
          --prefix LD_LIBRARY_PATH : ${
            lib.makeLibraryPath ([
              glib
              webkitgtk_4_1
            ])
          } \
          --set WEBKIT_DISABLE_DMABUF_RENDERER 1 \
          --prefix PATH : ${jdk}/bin

        install -Dm444 icon.xpm $out/share/icons/hicolor/256x256/apps/archi.xpm

        runHook postInstall
      ''
    else
      ''
        runHook preInstall

        mkdir -p "$out/Applications"
        mv Archi.app "$out/Applications/"

        runHook postInstall
      '';

  desktopItems = [
    (makeDesktopItem {
      name = "archi";
      desktopName = "Archi";
      exec = "Archi";
      type = "Application";
      comment = meta.description;
      icon = "archi";
      categories = [
        "Development"
      ];
    })
  ];

  passthru.updateScript = ./update.sh;

  passthru.tests = { inherit (nixosTests) archi; };

  meta = with lib; {
    description = "ArchiMate modelling toolkit";
    longDescription = ''
      Archi is an open source modelling toolkit to create ArchiMate
      models and sketches.
    '';
    homepage = "https://www.archimatetool.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [
      earldouglas
      paumr
    ];
    mainProgram = "Archi";
  };
}
