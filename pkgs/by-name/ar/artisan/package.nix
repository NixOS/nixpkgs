{
  lib,
  appimageTools,
  fetchurl,
  nix-update-script,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "artisan";
  version = "4.0.2";

  src = fetchurl {
    url = "https://github.com/artisan-roaster-scope/artisan/releases/download/v${finalAttrs.version}/artisan-linux-${finalAttrs.version}.AppImage";
    hash = "sha256-KmjqM3gYpxxjEBaXjF5zvL8bgfgD8IKvAX0xYf29J48=";
  };

  extraInstallCommands = ''
    install -m 444 -D ${finalAttrs.contents}/org.artisan_scope.artisan.desktop $out/share/applications/org.artisan_scope.artisan.desktop
    install -m 444 -D ${finalAttrs.contents}/artisan.png $out/share/applications/artisan.png
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=v([\\d.]+)" ];
  };

  meta = {
    description = "Visual scope for coffee roasters";
    homepage = "https://artisan-scope.org/";
    changelog = "https://github.com/artisan-roaster-scope/artisan/releases/tag/v${finalAttrs.version}";
    downloadPage = "https://github.com/artisan-roaster-scope/artisan/releases";
    license = lib.licenses.gpl3Only;
    mainProgram = "artisan";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ bohreromir ];
    platforms = [ "x86_64-linux" ];
  };
})
