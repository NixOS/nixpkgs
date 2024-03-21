{
  lib,
  fetchFromGitHub,
  makeFontsConf,
  buildLua,
}:
buildLua (finalAttrs: {
  pname = "modernx";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "zydezu";
    repo = "ModernX";
    rev = finalAttrs.version;
    sha256 = "sha256-rruscDutFyQCl5sTtQfmtYPcXKWU51/QFbghSOyMC9o=";
  };

  # the script uses custom "texture" fonts as the background for ui elements.
  # In order for mpv to find them, we need to adjust the fontconfig search path.
  postInstall = "cp -r *.ttf $out/share";
  passthru.extraWrapperArgs = [
    "--set"
    "FONTCONFIG_FILE"
    (toString (makeFontsConf {
      fontDirectories = ["${finalAttrs.finalPackage}/share/fonts"];
    }))
  ];

  meta = with lib; {
    description = "Fork of modernX (a replacement for MPV that retains the functionality of the default OSC), adding additional features.";
    homepage = "https://github.com/zydezu/ModernX";
    license = licenses.unlicense;
    maintainers = with lib.maintainers; [luftmensch-luftmensch];
  };
})
