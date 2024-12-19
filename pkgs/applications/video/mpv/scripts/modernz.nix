{
  lib,
  buildLua,
  fetchFromGitHub,
  makeFontsConf,
  nix-update-script,
}:
buildLua (finalAttrs: {
  pname = "modernx";
  version = "0.2.2";

  scriptPath = "modernz.lua";
  src = fetchFromGitHub {
    owner = "Samillion";
    repo = "ModernZ";
    rev = "v${finalAttrs.version}";
    hash = "sha256-h6bWrFLZp5MuNrE/Ap6pzSqUTMhgCWpp67SXN0d+4Jg=";
  };

  postInstall = ''
    install -Dt $out/share/fonts *.ttf
  '';

  passthru.extraWrapperArgs = [
    "--set"
    "FONTCONFIG_FILE"
    (toString (makeFontsConf {
      fontDirectories = [ "${finalAttrs.finalPackage}/share/fonts" ];
    }))
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Sleek and modern OSC for mpv designed to enhance functionality by adding more features, all while preserving the core standards of mpv's OSC";
    homepage = "https://github.com/Samillion/ModernZ";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ Guanran928 ];
  };
})
