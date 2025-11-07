{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "noTunes";
  version = "3.5";

  src = fetchurl {
    url = "https://github.com/tombonez/noTunes/releases/download/v${finalAttrs.version}/noTunes-${finalAttrs.version}.zip";
    hash = "sha256-B4Nc+fO/MU0R8uvlKAcqIA/6LVXzjeWQhZecLUduo9U=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';

  meta = with lib; {
    description = "A simple macOS application that will prevent iTunes or Apple Music from launching.";
    homepage = "https://github.com/tombonez/noTunes";
    license = licenses.mit;
    maintainers = with maintainers; [ rickyelopez ];
    platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
