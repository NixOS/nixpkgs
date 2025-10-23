{
  lib,
  stdenvNoCC,
  fetchurl,
  nix-update-script,
  unzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mediamate";
  version = "3.8.2_316";

  src = fetchurl {
    url = "https://github.com/Wouter01/MediaMate-Releases/releases/download/v${finalAttrs.version}/MediaMate_v${
      lib.strings.replaceStrings [ "_" ] [ "-" ] finalAttrs.version
    }.zip";
    hash = "sha256-O+V7x0AJBgsPL7clEpQYvvE38/0IxyN8J4tptxCmgo0=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "New, fresh visuals for changing your volume, brightness and now playing media";
    homepage = "https://wouter01.github.io/MediaMate/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ FlameFlag ];
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
