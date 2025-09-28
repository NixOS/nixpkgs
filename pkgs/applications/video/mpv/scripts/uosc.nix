{
  lib,
  fetchFromGitHub,
  gitUpdater,
  makeFontsConf,
  buildLua,
  buildGoModule,
}:

buildLua (finalAttrs: {
  pname = "uosc";
  version = "5.12.0";
  scriptPath = "src/uosc";

  src = fetchFromGitHub {
    owner = "tomasklaen";
    repo = "uosc";
    rev = finalAttrs.version;
    hash = "sha256-vSs6X++WIM9NfTvcsJgwiKmTuU0eu3i3cffsdCVSyV4=";
  };
  passthru.updateScript = gitUpdater { };

  tools = buildGoModule {
    pname = "uosc-bin";
    inherit (finalAttrs) version src;
    vendorHash = "sha256-oRXChHeVQj6nXvKOVV125sM8wD33Dxxv0r/S7sl6SxQ=";
  };

  # the script uses custom "texture" fonts as the background for ui elements.
  # In order for mpv to find them, we need to adjust the fontconfig search path.
  postInstall = "cp -r src/fonts $out/share";
  passthru.extraWrapperArgs = [
    "--set"
    "FONTCONFIG_FILE"
    (toString (makeFontsConf {
      fontDirectories = [ "${finalAttrs.finalPackage}/share/fonts" ];
    }))
    "--set"
    "MPV_UOSC_ZIGGY"
    (lib.getExe' finalAttrs.tools "ziggy")
  ];

  meta = with lib; {
    description = "Feature-rich minimalist proximity-based UI for MPV player";
    homepage = "https://github.com/tomasklaen/uosc";
    license = licenses.gpl3Only;
    maintainers = with lib.maintainers; [ apfelkuchen6 ];
  };
})
