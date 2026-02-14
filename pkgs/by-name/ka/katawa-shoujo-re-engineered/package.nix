{
  lib,
  stdenvNoCC,
  fetchFromCodeberg,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  renpy,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "katawa-shoujo-re-engineered";
  version = "2.0.3";

  src = fetchFromCodeberg {
    # GitHub mirror at fleetingheart/ksre
    owner = "fhs";
    repo = "katawa-shoujo-re-engineered";
    rev = "v${finalAttrs.version}";
    hash = "sha256-M2TWc5dl7lkwM/oisM6xtJwb3Dw9i6qUadBHGdEO2bs=";
  };

  desktopItems = [
    (makeDesktopItem {
      name = "katawa-shoujo-re-engineered";
      desktopName = "Katawa Shoujo: Re-Engineered";
      type = "Application";
      icon = finalAttrs.meta.mainProgram;
      categories = [ "Game" ];
      exec = finalAttrs.meta.mainProgram;
    })
  ];

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
    renpy
  ];

  configurePhase = ''
    runHook preConfigure

    substituteInPlace game/config.rpy --replace-fail 0.0.0-localbuild ${finalAttrs.version}

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    renpy . compile

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    phome=$out/share/kataswa-shoujo-re-engineered
    mkdir -p $phome
    cp -r game $phome
    find $phome -type f -name "*.rpy" -delete
    makeWrapper ${lib.getExe renpy} $out/bin/${finalAttrs.meta.mainProgram} \
      --add-flags $phome --add-flags run
    install -D $src/web-icon.png $out/share/icons/hicolor/512x512/apps/${finalAttrs.meta.mainProgram}.png

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fan-made modernization of the classic visual novel Katawa Shoujo";
    homepage = "https://www.fhs.sh/projects";
    license = with lib.licenses; [
      # code
      mpl20
      # assets from the original game
      cc-by-nc-nd-30
    ];
    mainProgram = "katawa-shoujo-re-engineered";
    maintainers = with lib.maintainers; [
      quantenzitrone
      rapiteanu
      ulysseszhan
    ];
    platforms = renpy.meta.platforms;
  };
})
