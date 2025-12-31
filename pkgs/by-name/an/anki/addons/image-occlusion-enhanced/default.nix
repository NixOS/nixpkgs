{
  lib,
  anki-utils,
  fetchFromGitHub,
  nix-update-script,
}:
anki-utils.buildAnkiAddon (finalAttrs: {
  pname = "image-occlusion-enhanced";
  version = "1.4.0";
  src = fetchFromGitHub {
    owner = "glutanimate";
    repo = "image-occlusion-enhanced";
    sparseCheckout = [ "src/image_occlusion_enhanced" ];
    tag = "v${finalAttrs.version}";
    hash = "sha256-YR1hicBDb08J+1Qc+SDiJDXLo5FzLqCQGeVe7brbPME=";
  };
  sourceRoot = "${finalAttrs.src.name}/src/image_occlusion_enhanced";
  passthru.updateScript = nix-update-script { };
  meta = {
    description = ''
      Adds extra features for creating image-based cloze-deletions
    '';
    homepage = "https://github.com/glutanimate/image-occlusion-enhanced";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ dastarruer ];
  };
})
