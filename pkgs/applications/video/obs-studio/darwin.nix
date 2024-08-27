{
  stdenvNoCC,
  lib,

  fetchurl,
  undmg,

  pname,
  version,
  meta
}:

let
  sources = {
    "x86_64-darwin" = {
      url = "https://github.com/obsproject/obs-studio/releases/download/${version}/OBS-Studio-${version}-macOS-Intel.dmg";
      hash = "sha256-ZW57Br9gYOa+4QHnkXylBwFlb7b+l4i86zN28kWV6dM=";
    };
    "aarch64-darwin" = {
      url = "https://github.com/obsproject/obs-studio/releases/download/${version}/OBS-Studio-${version}-macOS-Apple.dmg";
      hash = "sha256-ZxT4/LyNwfa5KsHaWOLHVw3GX++4GdaFNjdXEZc74Ps=";
    };
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit pname version;

  src = fetchurl (sources.${stdenvNoCC.system} or (throw "unsupported system ${stdenvNoCC.hostPlatform.system}"));

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';

  meta = meta // {
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ iivusly ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
