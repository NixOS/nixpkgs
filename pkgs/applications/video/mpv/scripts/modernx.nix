{ lib
, buildLua
, fetchFromGitHub
, makeFontsConf
, nix-update-script
}:
buildLua (finalAttrs: {
  pname = "modernx";
  version = "0.6.0";

  scriptPath = "modernx.lua";
  src = fetchFromGitHub {
    owner = "cyl0";
    repo = "ModernX";
    rev = finalAttrs.version;
    hash = "sha256-Gpofl529VbmdN7eOThDAsNfNXNkUDDF82Rd+csXGOQg=";
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
    homepage = "https://github.com/cyl0/ModernX";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ Guanran928 ];
  };
})
