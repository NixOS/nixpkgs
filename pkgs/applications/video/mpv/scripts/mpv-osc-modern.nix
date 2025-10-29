{
  lib,
  buildLua,
  fetchFromGitHub,
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

  postInstall = ''
    mkdir -p $out/share/fonts
    cp -r *.ttf $out/share/fonts
  '';
  passthru.extraWrapperArgs = [
    "--set"
    "FONTCONFIG_FILE"
    (toString (makeFontsConf {
      fontDirectories = [ "${finalAttrs.finalPackage}/share/fonts" ];
    }))
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Another MPV OSC Script";
    homepage = "https://github.com/maoiscat/mpv-osc-modern";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ Guanran928 ];
  };
})
