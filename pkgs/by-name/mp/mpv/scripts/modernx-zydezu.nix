{
  lib,
  buildLua,
  fetchFromGitHub,
  installFonts,
  mpvScripts,
  nix-update-script,
}:
buildLua (finalAttrs: {
  pname = "modernx-zydezu";
  version = "0.4.8";

  scriptPath = "modernx.lua";
  src = fetchFromGitHub {
    owner = "zydezu";
    repo = "ModernX";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kUqwksdNf8xWmzF+ZRy1VZQ/tQWhEOC7TeyOoyrWsvg=";
  };

  nativeBuildInputs = [ installFonts ];

  passthru.fontDirectories = [ "${finalAttrs.finalPackage}/share/fonts" ];

  passthru.updateScript = nix-update-script { };

  # FIXME?: collides with mpvScripts.modernx
  passthru.dontCollideCheck = lib.hasAttr "modernx" mpvScripts;

  meta = {
    description = "Modern OSC UI replacement for MPV that retains the functionality of the default OSC";
    changelog = "https://github.com/zydezu/ModernX/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/zydezu/ModernX";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [
      luftmensch-luftmensch
      Guanran928
    ];
  };
})
