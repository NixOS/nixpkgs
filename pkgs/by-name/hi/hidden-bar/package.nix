{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
}:

stdenvNoCC.mkDerivation rec {
  pname = "hidden-bar";
  version = "1.9";

  src = fetchurl {
    url = "https://github.com/dwarvesf/hidden/releases/download/v${version}/Hidden.Bar.${version}.dmg";
    hash = "sha256-P1SwJPXBxAvBiuvjkBRxAom0fhR+cVYfriKmYcqybQI=";
  };

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    mv "Hidden Bar.app" $out/Applications

    runHook postInstall
  '';

  nativeBuildInputs = [ undmg ];

  meta = {
    description = "Ultra-light MacOS utility that helps hide menu bar icons";
    homepage = "https://github.com/dwarvesf/hidden";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ donteatoreo ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
