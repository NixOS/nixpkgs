{
  lib,
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mac-mouse-fix";
  version = "3.0.8";

  src = fetchzip {
    url = "https://github.com/noah-nuebling/mac-mouse-fix/releases/download/${finalAttrs.version}/MacMouseFixApp.zip";
    hash = "sha256-yqOxnhrceYoT46KGpk+nzFTgwOCtL9hGpu/ifUO0E6A=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -R "Mac Mouse Fix.app" "$out/Applications/"

    runHook postInstall
  '';

  meta = {
    description = "Make your mouse better on macOS with smooth scrolling, gestures, and customizable buttons";
    homepage = "https://noah-nuebling.github.io/mac-mouse-fix-website";
    changelog = "https://github.com/noah-nuebling/mac-mouse-fix/releases/tag/${finalAttrs.version}";
    # Custom license based on MIT/DBAD. Restricts commercial redistribution of
    # compiled binaries and requires keeping monetization systems intact.
    # Not OSI/FSF "free" due to commercial redistribution restrictions.
    license = {
      fullName = "MMF License";
      url = "https://github.com/noah-nuebling/mac-mouse-fix/blob/${finalAttrs.version}/License";
      free = false;
    };
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ shgew ];
    platforms = lib.platforms.darwin;
    mainProgram = "Mac Mouse Fix";
  };
})
