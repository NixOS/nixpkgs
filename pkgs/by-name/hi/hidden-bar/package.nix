{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "hidden-bar";
  version = "1.13.0";

  src = fetchurl {
    url = "https://github.com/dwarvesf/hidden/releases/download/v${version}/Hidden-Bar-v${version}-macos.zip";
    hash = "sha256-qBFxfYT6ukeOpmyqIk8zYKnl2ESnpQ+gkAnzLXgTGkQ=";
  };

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    mv "Hidden Bar.app" $out/Applications

    runHook postInstall
  '';

  nativeBuildInputs = [ unzip ];

  meta = {
    description = "Ultra-light MacOS utility that helps hide menu bar icons";
    homepage = "https://github.com/dwarvesf/hidden";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ _4evy ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
