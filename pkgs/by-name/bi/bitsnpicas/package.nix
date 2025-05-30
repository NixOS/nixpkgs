{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  jdk,
  jre,
  zip,
  makeWrapper,
  spleen,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bitsnpicas";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "kreativekorp";
    repo = "bitsnpicas";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hw7UuzesqpmnTjgpfikAIYyY70ni7BxjaUtHAPEdkXI=";
  };

  nativeBuildInputs = [
    jdk
    zip
    makeWrapper
  ];

  sourceRoot = "${finalAttrs.src.name}/main/java/BitsNPicas";

  installPhase =
    ''
      runHook preInstall

      install -Dm444 BitsNPicas.jar "$out/share/java/bitsnpicas.jar"
      install -Dm444 MapEdit.jar "$out/share/java/mapedit.jar"
      install -Dm444 KeyEdit.jar "$out/share/java/keyedit.jar"

      makeWrapper "${jre}/bin/java" "$out/bin/bitsnpicas" \
        --add-flags "-jar $out/share/java/bitsnpicas.jar"
      makeWrapper "${jre}/bin/java" "$out/bin/mapedit" \
        --add-flags "-jar $out/share/java/mapedit.jar"
      makeWrapper "${jre}/bin/java" "$out/bin/keyedit" \
        --add-flags "-jar $out/share/java/keyedit.jar"

      install -Dm444 dep/bitsnpicas.png "$out/share/icons/hicolor/128x128/apps/bitsnpicas.png"
      install -Dm444 dep/kbnp-icon.png "$out/share/icons/hicolor/512x512/apps/bitsnpicas.png"
      install -Dm444 dep/mapedit-icon.png "$out/share/icons/hicolor/512x512/apps/mapedit.png"
      install -Dm444 dep/keyedit-icon.png "$out/share/icons/hicolor/256x256/apps/keyedit.png"
    ''
    + lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
      mkdir -p "$out/share/applications/"
      cp dep/*.desktop "$out/share/applications/"
    ''
    + ''
      runHook postInstall
    '';

  postFixup = lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
    substituteInPlace "$out/share/applications/bitsnpicas.desktop" \
      --replace-fail 'Exec=java -jar /usr/local/lib/bitsnpicas.jar' "Exec=$out/bin/bitsnpicas" \
      --replace-fail 'Icon=/usr/share' "Icon=$out/share"
    substituteInPlace "$out/share/applications/mapedit.desktop" \
      --replace-fail 'Exec=java -jar /usr/local/lib/mapedit.jar' "Exec=$out/bin/mapedit" \
      --replace-fail 'Icon=/usr/share' "Icon=$out/share"
    substituteInPlace "$out/share/applications/keyedit.desktop" \
      --replace-fail 'Exec=java -jar /usr/local/lib/keyedit.jar' "Exec=$out/bin/keyedit" \
      --replace-fail 'Icon=/usr/share' "Icon=$out/share"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    "$out/bin/bitsnpicas" convertbitmap -f psf "${spleen}/share/fonts/misc/spleen-8x16.bdf"
    [[ -f Spleen.psf ]]

    runHook postInstallCheck
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Bitmap and emoji font creation and conversion tools";
    homepage = "https://github.com/kreativekorp/bitsnpicas";
    # Written in https://github.com/kreativekorp/bitsnpicas/blob/v2.1/main/java/BitsNPicas/LICENSE
    license = lib.licenses.mpl11;
    mainProgram = "bitsnpicas";
    maintainers = with lib.maintainers; [
      kachick
    ];
    platforms = lib.platforms.all;
  };
})
