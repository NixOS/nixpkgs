{
  fetchFromGitHub,
  lib,
  stdenvNoCC,

  # build deps
  clickgen,
  python3Packages,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "maplestory-cursor";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Liam-Weitzel";
    repo = "maplestory-cursor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-doUnd0XyA7Nk078eDEIrRltj3zBODHpGn8Rqx2rl5/o=";
  };

  nativeBuildInputs = [
    clickgen
    python3Packages.attrs
  ];

  buildPhase = ''
    runHook preBuild

    ctgen build.toml -p x11 -o $out

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    mv $out/Maple $out/share/icons

    runHook postInstall
  '';

  meta = {
    description = "Maplestory cursor theme for x11 & wayland";
    homepage = "https://github.com/Liam-Weitzel/maplestory-cursor";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ liam-w ];
    platforms = lib.platforms.linux;
  };
})
