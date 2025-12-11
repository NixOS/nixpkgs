{
  lib,
  php,
  fetchFromGitHub,
  testers,
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "pretty-php";
  version = "0.4.95";

  src = fetchFromGitHub {
    owner = "lkrms";
    repo = "pretty-php";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V+xncL02fY0olGxqjWBWqD6N1J0XOeOPe55aULuN2bA=";
  };

  vendorHash = "sha256-62KnzttuLsDP7DlEING/koS7lxf5A673F5DwppJs3vw=";

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "HOME=$TMPDIR pretty-php --version";
    };
  };

  meta = {
    description = "Opinionated PHP code formatter";
    homepage = "https://github.com/lkrms/pretty-php";
    license = lib.licenses.mit;
    mainProgram = "pretty-php";
    maintainers = with lib.maintainers; [ piotrkwiecinski ];
  };
})
