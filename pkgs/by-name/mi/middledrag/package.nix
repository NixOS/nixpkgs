{
  lib,
  stdenvNoCC,
  fetchurl,
  xar,
  cpio,
}:

stdenvNoCC.mkDerivation {
  pname = "middledrag";
  version = "1.3.8.1";

  scr = fetchurl {
    url = "https://github.com/m1dugh/middledrag/releases/download/v${version}/middledrag-${version}.dmg";
    sha256 = "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef";
  };

  nativeBuildInputs = [
    xar
    cpio
  ];

  unpackPhase = ''
    xar -x -f $src
    cd middledrag.pkg
    gunzip -dc Payload | cpio -i
  '';

  sourceRoot = "MiddleDrag.app";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -r $sourceRoot $out/Applications/MiddleDrag.app
    runHook postInstall
  '';

  meta = with lib; {
    description = "Three-finger click and drag simulation for macOS trackpads";
    homepage = "https://middledrag.app";
    license = licenses.mit;
    platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = with maintainers; [ nullpointerdepressivedisorder ];
    sourceProvenance = with sourceProvenance; [ binaryNativeCode ];
  };
}
