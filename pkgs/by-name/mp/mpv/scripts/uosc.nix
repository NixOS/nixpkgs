{
  lib,
  fetchFromGitHub,
  gitUpdater,
  buildLua,
  buildGoModule,
  installFonts,
}:

buildLua (finalAttrs: {
  pname = "uosc";
  version = "5.13.0";
  scriptPath = "src/uosc";

  src = fetchFromGitHub {
    owner = "tomasklaen";
    repo = "uosc";
    rev = finalAttrs.version;
    hash = "sha256-5fHihGI2rodEByqTRs3NasmLUBjG3VY9l/YnKDCKSt8=";
  };
  passthru.updateScript = gitUpdater { };

  nativeBuildInputs = [ installFonts ];

  tools = buildGoModule {
    pname = "uosc-bin";
    inherit (finalAttrs) version src;
    vendorHash = "sha256-oRXChHeVQj6nXvKOVV125sM8wD33Dxxv0r/S7sl6SxQ=";
  };

  # the script uses custom "texture" fonts as the background for ui elements.
  passthru.fontDirectories = [ "${finalAttrs.finalPackage}/share/fonts" ];
  passthru.extraWrapperArgs = [
    "--set"
    "MPV_UOSC_ZIGGY"
    (lib.getExe' finalAttrs.tools "ziggy")
  ];

  meta = {
    description = "Feature-rich minimalist proximity-based UI for MPV player";
    homepage = "https://github.com/tomasklaen/uosc";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ apfelkuchen6 ];
  };
})
