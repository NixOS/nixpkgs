{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "plasma-plugin-blurredwallpaper";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "bouteillerAlan";
    repo = "blurredwallpaper";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hXuJhSS5QEgKWn60ctF3N+avfez8Ktrne3re/FY/VMU=";
  };

  installPhase = ''
    runHook preInstall
    install -d $out/share/plasma/wallpapers/a2n.blur{,.plasma5}
    cp -r a2n.blur{,.plasma5} $out/share/plasma/wallpapers/
    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Plasma 6 wallpaper plugin to blur the wallpaper of active window";
    homepage = "https://github.com/bouteillerAlan/blurredwallpaper";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      dr460nf1r3
      johnrtitor
    ];
    platforms = lib.platforms.linux;
  };
})
