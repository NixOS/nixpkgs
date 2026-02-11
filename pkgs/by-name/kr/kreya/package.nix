{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  wrapGAppsHook4,
  autoPatchelfHook,
  btar,
  icu,
  gtk4,
  webkitgtk_6_0,
  openssl,
}:

let
  libraries = [
    icu
    (lib.getLib stdenv.cc.cc)
    gtk4
    webkitgtk_6_0
    openssl
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "kreya";
  version = "1.18.0";

  src = fetchurl {
    url = "https://stable-downloads.kreya.app/${finalAttrs.version}/Kreya-linux-x64.tar.gz";
    hash = "sha256-oXDR1vwU0ikDq4eHFOXTlDgpODH6kVQu/2Ghed9c508=";
  };

  nativeBuildInputs = [
    makeWrapper
    autoPatchelfHook
    wrapGAppsHook4
  ];

  buildInputs = libraries;

  installPhase = ''
    runHook preInstall

    install -Dm755 kreya -t $out/bin
    install -Dm755 *.so -t $out/lib

    mkdir -p $out/share/kreya/
    cp -r example-project $out/share/kreya/
    cp -r protoc $out/share/kreya/
    cp kreya.xml $out/share/kreya/

    wrapProgram $out/bin/kreya \
      --set LD_LIBRARY_PATH "$out/lib:${lib.makeLibraryPath libraries}"

    runHook postInstall
  '';

  dontStrip = true;

  meta = {
    description = "Kreya is a GUI client for gRPC and REST APIs";
    homepage = "https://kreya.app/";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ maxmosk ];
  };
})
