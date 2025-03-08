{
  lib,
  buildLua,
  fetchFromGitHub,
  makeFontsConf,
  nix-update-script,
}:
buildLua (finalAttrs: {
  pname = "modernx";
  version = "0.6.1";

  scriptPath = "modernx.lua";
  src = fetchFromGitHub {
    owner = "cyl0";
    repo = "ModernX";
    rev = finalAttrs.version;
    hash = "sha256-q7DwyfmOIM7K1L7vvCpq1EM0RVpt9E/drhAa9rLYb1k=";
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
    description = "Modern OSC UI replacement for MPV that retains the functionality of the default OSC";
    homepage = "https://github.com/cyl0/ModernX";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ Guanran928 ];
  };
})
