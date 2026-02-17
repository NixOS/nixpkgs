{
  stdenvNoCC,
  lib,
  fetchzip,
  makeWrapper,
}:
stdenvNoCC.mkDerivation {
  pname = "roblox";
  version = "0.724.0.7240735";

  __structuredAttrs = true;
  strictDeps = true;

  src =
    if stdenvNoCC.hostPlatform.isAarch64 then
      (fetchzip {
        url = "https://web.archive.org/web/20260604191635/http://setup.rbxcdn.com/mac/arm64/version-b6bc8a3f6c184e6f-RobloxPlayer.zip";
        stripRoot = false;
        hash = "sha256-l2p7zSjV8bZvetQyVVjRdy693hVk7SrBHxeGgIv1GdE=";
      })
    else
      (fetchzip {
        url = "https://web.archive.org/web/20260604190615/http://setup.rbxcdn.com/mac/version-b6bc8a3f6c184e6f-RobloxPlayer.zip";
        stripRoot = false;
        hash = "sha256-RvvgH9iHpLHovQ66IGN3ojvMM3Z3fcz1SXgsL+krmlw=";
      });

  sourceRoot = ".";

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r $src/*.app $out/Applications

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Multiplayer game platform designed for playing games";
    homepage = "https://www.roblox.com";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ eveeifyeve ];
    mainProgram = "RobloxPlayer.app";
    platforms = lib.platforms.darwin;
  };
}
