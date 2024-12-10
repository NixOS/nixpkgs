{
  lib,
  stdenvNoCC,
  fetchFromGitea,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  renpy,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "katawa-shoujo-re-engineered";
  version = "1.4.8";

  src = fetchFromGitea {
    # GitHub mirror at fleetingheart/ksre
    domain = "codeberg.org";
    owner = "fhs";
    repo = "katawa-shoujo-re-engineered";
    rev = "v${finalAttrs.version}";
    hash = "sha256-y128bnRZtW5DgiP43OAnkhhq3f5F88jUl1Bku6wef+w=";
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
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    makeWrapper ${lib.getExe' renpy "renpy"} $out/bin/${finalAttrs.meta.mainProgram} \
      --add-flags ${finalAttrs.src} --add-flags run
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
    ];
    platforms = renpy.meta.platforms;
  };
})
