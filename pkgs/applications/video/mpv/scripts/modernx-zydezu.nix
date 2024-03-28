{ lib
, buildLua
, fetchFromGitHub
, makeFontsConf
, nix-update-script
}:
buildLua (finalAttrs: {
  pname = "modernx-zydezu";
  version = "0.2.8";

  scriptPath = "modernx.lua";
  src = fetchFromGitHub {
    owner = "zydezu";
    repo = "ModernX";
    rev = finalAttrs.version;
    hash = "sha256-rruscDutFyQCl5sTtQfmtYPcXKWU51/QFbghSOyMC9o=";
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
    description = "A modern OSC UI replacement for MPV that retains the functionality of the default OSC";
    homepage = "https://github.com/zydezu/ModernX";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ Guanran928 ];
  };
})
