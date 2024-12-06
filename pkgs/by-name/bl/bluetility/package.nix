{ lib
, stdenvNoCC
, fetchurl
, unzip
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bluetility";
  version = "1.5.1";

  src = fetchurl {
    url = "https://github.com/jnross/Bluetility/releases/download/${finalAttrs.version}/Bluetility.app.zip";
    hash = "sha256-Batnv06nXXxvUz+DlrH1MpeL4f5kNSPDH6Iqd/UiFbw=";
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
    description = "Bluetooth Low Energy browse";
    homepage = "https://github.com/jnross/Bluetility";
    license = licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.darwin;
  };
})
