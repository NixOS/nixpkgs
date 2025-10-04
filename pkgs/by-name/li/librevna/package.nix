{
  stdenv,
  lib,
  fetchFromGitHub,
  apple-sdk_14,
  pkg-config,
  qt6,
  libusb1,
  udev,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "librevna";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "jankae";
    repo = "LibreVNA";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3iQO4iUhRJWFqqrMMKXslPm8wtl+WaEa9HTrv5bKHJ4=";
  };

  sourceRoot = "${finalAttrs.src.name}/Software/PC_Application/LibreVNA-GUI";

  postPatch = ''
    substituteInPlace resources/librevna.desktop \
      --replace-warn Exec=/opt/LibreVNA-GUI Exec=$out/bin/LibreVNA-GUI
  '';

  nativeBuildInputs = [
    pkg-config
    qt6.qmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    libusb1
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux udev
  ++ lib.optional stdenv.hostPlatform.isDarwin apple-sdk_14;

  installPhase =
    if stdenv.hostPlatform.isDarwin then
      ''
        runHook preInstall

        mkdir -p $out/{Applications,bin}
        mv LibreVNA-GUI.app $out/Applications
        ln -s $out/Applications/LibreVNA-GUI.app/Contents/MacOS/LibreVNA-GUI $out/bin/LibreVNA-GUI

        runHook postInstall
      ''
    else
      ''
        runHook preInstall

        install -Dm755 LibreVNA-GUI -t $out/bin
        install -Dm644 ../51-vna.rules -t $out/etc/udev/rules.d
        install -Dm644 resources/librevna.desktop -t $out/share/applications
        install -Dm644 resources/librevna.png -t $out/share/pixmaps

        runHook postInstall
      '';

  meta = {
    changelog = "https://github.com/jankae/LibreVNA/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/jankae/LibreVNA/";
    description = "100kHz to 6GHz 2 port USB based VNA";
    mainProgram = "LibreVNA-GUI";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;

    maintainers = with lib.maintainers; [
      dunxen
    ];
  };
})
