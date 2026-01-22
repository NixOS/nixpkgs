{
  lib,
  stdenvNoCC,
  fetchurl,
  xar,
  cpio,
}:

stdenvNoCC.mkDerivation rec {
  pname = "middledrag";
  version = "1.3.8.9";

  src = fetchurl {
    url = "https://github.com/NullPointerDepressiveDisorder/MiddleDrag/releases/download/v${version}/MiddleDrag-${version}.pkg";
    hash = "sha256-eN4d488JuhwlW2HTJhrxWZsLZkjfUY4EvG7rGn0RZ2c=";
  };

  nativeBuildInputs = [
    xar
    cpio
  ];

  unpackPhase = ''
    xar -x -f $src
    cat Payload | gunzip -dc | cpio -i
  '';

  sourceRoot = "Applications/MiddleDrag.app";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -r . $out/Applications/MiddleDrag.app
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
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "MiddleDrag";
  };
}
