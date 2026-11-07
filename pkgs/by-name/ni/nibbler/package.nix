{
  lib,
  stdenv,
  fetchFromGitHub,
  electron,
  makeBinaryWrapper,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nibbler";
  version = "2.5.8";

  src = fetchFromGitHub {
    owner = "rooklift";
    repo = "nibbler";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wB4UjgPg7Y1jJPC6Wl10atZaVplnDL/hZyfEiq11/ck=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  dontBuild = true;

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/nibbler $out/bin
    cp -r files/src/* $out/share/nibbler/

    install -Dm644 files/res/nibbler.png -t $out/share/icons/hicolor/512x512/apps
    install -Dm644 files/res/nibbler.svg -t $out/share/icons/hicolor/scalable/apps
    install -Dm644 files/res/linux/nibbler.desktop -t $out/share/applications

    makeWrapper '${lib.getExe electron}' "$out/bin/nibbler" \
      --add-flags "$out/share/nibbler" \
      --inherit-argv0

    runHook postInstall
  '';

  meta = {
    description = "A real-time analysis GUI for Leela Chess Zero";
    homepage = "https://github.com/rooklift/nibbler";
    changelog = "https://github.com/rooklift/nibbler/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ oati ];
    mainProgram = "nibbler";
  };
})
