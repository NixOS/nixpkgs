{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mos";
  version = "3.5.0";

  src = fetchurl {
    url = "https://github.com/Caldis/Mos/releases/download/${finalAttrs.version}/Mos.Versions.${finalAttrs.version}.dmg";
    hash = "sha256-o2H4cfMudjoQHfKeV4ORiO9/szoomFP0IP6D6ecMAI4=";
  };
  sourceRoot = ".";

  nativeBuildInputs = [
    undmg
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -r *.app $out/Applications
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Smooths scrolling and set mouse scroll directions independently on macOS";
    homepage = "https://mos.caldis.me/";
    changelog = "https://github.com/Caldis/Mos/releases/tag/${finalAttrs.version}";
    license = licenses.cc-by-nc-40;
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = platforms.darwin;
  };
})
