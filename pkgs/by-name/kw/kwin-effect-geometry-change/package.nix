{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  kdePackages,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kwin-effect-geometry-change";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "peterfajdiga";
    repo = "kwin4_effect_geometry_change";
    tag = "v${lib.versions.majorMinor finalAttrs.version}";
    hash = "sha256-p4FpqagR8Dxi+r9A8W5rGM5ybaBXP0gRKAuzigZ1lyA=";
  };

  nativeBuildInputs = [
    kdePackages.kpackage
    kdePackages.kwin
  ];

  dontBuild = true;

  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall

    kpackagetool6 --type=KWin/Effect --install=./package --packageroot=$out/share/kwin/effects

    runHook postInstall
  '';

  meta = {
    description = "KWin animation for windows moved or resized by programs or scripts";
    homepage = "https://github.com/peterfajdiga/kwin4_effect_geometry_change";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ CouldBeMathijs ];
  };
})
