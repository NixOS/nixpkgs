{
  lib,
  php,
  fetchFromGitHub,
  testers,
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "pretty-php";
  version = "0.4.94";

  src = fetchFromGitHub {
    owner = "lkrms";
    repo = "pretty-php";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zBhxuEViLxeQ9m3u1L0wYqeL+YEWWwvJS7PtsFPO5QU=";
  };

  vendorHash = "sha256-vnmp/HLzaOzHu22lzugRXIHL43YQ/hm223gcUbIiLT4=";

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
