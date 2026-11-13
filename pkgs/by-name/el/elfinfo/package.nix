{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "elfinfo";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "xyproto";
    repo = "elfinfo";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-8axP9DaTiJpQ9OHkqhZHPY5NDIuJfQYyDngMOEG4kkY=";
  };

  vendorHash = null;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Small utility for showing information about ELF files";
    mainProgram = "elfinfo";
    homepage = "https://elfinfo.roboticoverlords.org/";
    changelog = "https://github.com/xyproto/elfinfo/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
})
