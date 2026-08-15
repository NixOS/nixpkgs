{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "run";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "TekWizely";
    repo = "run";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-an5AuRJJEM18IssdLLZC/zzPpsVCCtawRQXK/AfzMN0=";
  };

  vendorHash = "sha256-BAyhuE9hGGDfDGmXQ7dseUvHlK5vC87uLT78lHSvLeg=";

  doCheck = false;

  meta = {
    description = "Easily manage and invoke small scripts and wrappers";
    mainProgram = "run";
    homepage = "https://github.com/TekWizely/run";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      rawkode
    ];
  };
})
