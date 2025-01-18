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

  meta = with lib; {
    description = "Ultra-light MacOS utility that helps hide menu bar icons";
    homepage = "https://github.com/dwarvesf/hidden";
    license = licenses.mit;
    maintainers = with maintainers; [ donteatoreo ];
    platforms = platforms.darwin;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
