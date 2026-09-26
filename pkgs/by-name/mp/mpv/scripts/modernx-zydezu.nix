{
  lib,
  buildLua,
  fetchFromGitHub,
  installFonts,
  makeFontsConf,
  mpvScripts,
  nix-update-script,
}:
buildLua (finalAttrs: {
  pname = "modernx-zydezu";
  version = "0.4.7";

  scriptPath = "modernx.lua";
  src = fetchFromGitHub {
    owner = "zydezu";
    repo = "ModernX";
    rev = finalAttrs.version;
    hash = "sha256-EekTzSC2Komh3H18IK1xr5bpQuAlulsc6CnmGb4aZ+A=";
  };

  nativeBuildInputs = [ installFonts ];

  passthru.extraWrapperArgs = [
    "--set"
    "FONTCONFIG_FILE"
    (toString (makeFontsConf {
      fontDirectories = [ "${finalAttrs.finalPackage}/share/fonts" ];
    }))
  ];

  passthru.updateScript = nix-update-script { };

  # FIXME?: collides with mpvScripts.modernx
  passthru.dontCollideCheck = lib.hasAttr "modernx" mpvScripts;

  meta = {
    description = "Modern OSC UI replacement for MPV that retains the functionality of the default OSC";
    changelog = "https://github.com/zydezu/ModernX/releases/tag/${finalAttrs.version}";
    homepage = "https://github.com/zydezu/ModernX";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [
      luftmensch-luftmensch
      Guanran928
    ];
  };
})
