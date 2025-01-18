{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "swift-quit";
  version = "1.5";

  src = fetchurl {
    url = "https://github.com/onebadidea/swiftquit/releases/download/v${finalAttrs.version}/Swift.Quit.zip";
    sha256 = "sha256-pORnyxOhTc/zykBHF5ujsWEZ9FjNauJGeBDz9bnHTvs=";
  };
  dontUnpack = true;

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    unzip -d $out/Applications $src

    runHook postInstall
  '';

  meta = with lib; {
    description = "Automatic quitting of macOS apps when closing their windows.";
    homepage = "https://swiftquit.com/";
    license = licenses.gpl3;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ Enzime ];
    platforms = platforms.darwin;
  };
})
