{
  lib,
  fetchFromGitHub,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "pest";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "pestphp";
    repo = "pest";
    rev = "v${finalAttrs.version}";
    hash = "sha256-HLUzXL05hcTLcBhKvf/PPJoCmEYdFqNkBbiRAQfR9ik=";
  };

  composerLock = ./composer.lock;

  vendorHash = "sha256-rd15W3aHot1MtLGZeU2QREnIE5wtNw28OSpli3Nye5Y=";

  meta = {
    changelog = "https://github.com/pestphp/pest/releases/tag/v${finalAttrs.version}";
    description = "PHP testing framework";
    homepage = "https://pestphp.com";
    license = lib.licenses.mit;
    mainProgram = "pest";
    maintainers = [ ];
  };
})
