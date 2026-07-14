{
  lib,
  buildLua,
  fetchFromGitHub,
  installFonts,
  makeFontsConf,
  nix-update-script,
}:
buildLua (finalAttrs: {
  pname = "mpv-osc-modern";
  version = "1.1.1";

  scriptPath = "modern.lua";
  src = fetchFromGitHub {
    owner = "maoiscat";
    repo = "mpv-osc-modern";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RMUy8UpSRSCEPAbnGLpJ2NjDsDdkjq8cNsdGwsQ5ANU=";
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
    description = "Another MPV OSC Script";
    homepage = "https://github.com/maoiscat/mpv-osc-modern";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ Guanran928 ];
  };
})
