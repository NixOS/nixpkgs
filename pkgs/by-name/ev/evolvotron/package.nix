{
  stdenv,
  lib,
  fetchFromGitHub,
  qt6,
  boost,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "evolvotron";
  version = "0.8.2";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "WickedSmoke";
    repo = "evolvotron";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Kbo1YIdq2tEDsB8zQBZ/DCcJEaTZ6qpdBd3EtaMb9eU=";
  };

  buildInputs = [
    qt6.qtbase
    boost
  ];

  nativeBuildInputs = [
    qt6.qmake
    qt6.wrapQtAppsHook
  ];

  qmakeFlags = [
    "VERSION_NUMBER=${finalAttrs.version}"
    "main.pro"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/man/man1
    install -m 755 evolvotron/evolvotron $out/bin
    install -m 755 evolvotron_mutate/evolvotron_mutate $out/bin
    install -m 755 evolvotron_render/evolvotron_render $out/bin
    install -m 644 man/man1/evolvotron.1 $out/share/man/man1
    install -m 644 man/man1/evolvotron_mutate.1 $out/share/man/man1
    install -m 644 man/man1/evolvotron_render.1 $out/share/man/man1
    install -D -m 644 dist/icon-48.png $out/share/icons/hicolor/48x48/apps/evolvotron.png
    install -D -m 644 dist/icon-128.png $out/share/icons/hicolor/128x128/apps/evolvotron.png
    install -D -m 644 dist/evolvotron.desktop $out/share/applications/evolvotron.desktop

    runHook postInstall
  '';

  meta = {
    description = "Interactive generative art program";
    homepage = "https://www.timday.com/share/evolvotron/";
    changelog = "https://github.com/WickedSmoke/evolvotron/blob/v${finalAttrs.version}/NEWS";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      jacobwinters
    ];
    platforms = lib.platforms.linux;
    mainProgram = "evolvotron";
  };
})
