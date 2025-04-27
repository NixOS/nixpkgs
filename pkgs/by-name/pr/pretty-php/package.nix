{
  lib,
  php,
  fetchFromGitHub,
  testers,
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "pretty-php";
  version = "0.4.93";

  src = fetchFromGitHub {
    owner = "lkrms";
    repo = "pretty-php";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5gFTL4hcnEMKrffMpLRfneq5zeMHH50fjpvZcnefJZ8=";
  };

  vendorHash = "sha256-cp6WPlEc3WCW19UqLgrqMv8zE9UrCiTuN+WqTpAsuWE=";

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "HOME=$TMPDIR pretty-php --version";
    };
  };

  meta = {
    description = "The opinionated PHP code formatter";
    homepage = "https://github.com/lkrms/pretty-php";
    license = lib.licenses.mit;
    mainProgram = "pretty-php";
    maintainers = with lib.maintainers; [ piotrkwiecinski ];
  };
})
