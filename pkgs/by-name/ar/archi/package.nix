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

stdenv.mkDerivation (finalAttrs: {
  pname = "Archi";
  version = "5.7.0";

  src =
    {
      "x86_64-linux" = fetchurl {
        url = "https://github.com/archimatetool/archi.io/releases/download/57/Archi-Linux64-${finalAttrs.version}.tgz";
        hash = "sha256-MIUlWt3GP/1oQAeq4W2xnhG63a2zhGldgyoyZ9lNOiI=";
      };
      "x86_64-darwin" = fetchurl {
        url = "https://github.com/archimatetool/archi.io/releases/download/57/Archi-Mac-${finalAttrs.version}.dmg";
        hash = "sha256-wIlhJ6XmhL5rMb5zwHJYwamCwV13PK53wi9uEXIga5I=";
      };
      "aarch64-darwin" = fetchurl {
        url = "https://github.com/archimatetool/archi.io/releases/download/57/Archi-Mac-Silicon-${finalAttrs.version}.dmg";
        hash = "sha256-2/w4+aKfjfTGLjjl/nOouFtnv7/kjmfezkrmSa4ablc=";
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
            lib.makeLibraryPath [
              glib
              webkitgtk_4_1
            ]
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
      comment = finalAttrs.meta.description;
      icon = "archi";
      categories = [
        "Development"
      ];
    })
  ];

  passthru.updateScript = ./update.sh;

  passthru.tests = { inherit (nixosTests) archi; };

  meta = {
    description = "ArchiMate modelling toolkit";
    longDescription = ''
      Archi is an open source modelling toolkit to create ArchiMate
      models and sketches.
    '';
    homepage = "https://www.archimatetool.com/";
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      earldouglas
      paumr
    ];
    mainProgram = "Archi";
  };
})
