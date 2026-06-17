{
  lib,
  buildLua,
  fetchFromGitHub,
  installFonts,
  makeFontsConf,
  nix-update-script,
}:
buildLua (finalAttrs: {
  pname = "modernx-zydezu";
  version = "0.4.5";

  scriptPath = "modernx.lua";
  src = fetchFromGitHub {
    owner = "zydezu";
    repo = "ModernX";
    rev = finalAttrs.version;
    hash = "sha256-a+StfEYQwt5NuELvanvZllrD2RQ0g9JBpCznMdSDM5Y=";
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
