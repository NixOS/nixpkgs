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
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "Liam-Weitzel";
    repo = "maplestory-cursor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NFkEwaeyD+vlp3sGz3Hq2R9adYZnv0huV4lyOOTEHuA=";
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
