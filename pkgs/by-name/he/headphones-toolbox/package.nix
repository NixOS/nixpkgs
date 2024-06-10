{ lib
, stdenv
, dpkg
, fetchurl
, autoPatchelfHook
, webkitgtk
}:

stdenv.mkDerivation (finalAttrs: {
  name = "headphones-toolbox";
  version = "0.0.5";

  src = fetchurl {
    url = "https://github.com/ploopyco/headphones-toolbox/releases/download/app-v${finalAttrs.version}/ploopy-headphones-toolbox_${finalAttrs.version}_amd64.deb";
    hash = "sha256-lWjmpybGcL3sbBng8zCTUtwYhlrQ6cCrKkhiu+g9MsE=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [
    webkitgtk
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv usr/bin $out
    mv usr/lib $out
    mv usr/share $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "UI for configuring Ploopy Headphones";
    homepage = "https://github.com/ploopyco/headphones-toolbox/";
    maintainers = with maintainers; [ knarkzel nyanbinary ];
    license = licenses.gpl3Only;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "headphones-toolbox";
  };
})
