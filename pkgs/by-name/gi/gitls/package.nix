{
  lib,
  buildGoModule,
  gitls,
  fetchFromGitHub,
  testers,
}:

buildGoModule rec {
  pname = "gitls";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "hahwul";
    repo = "gitls";
    rev = "v${version}";
    hash = "sha256-kLkH/nNidd1QNPKvo7fxZwMhTgd4AVB8Ofw0Wo0z6c0=";
  };

  vendorHash = null;

  passthru.tests.version = testers.testVersion {
    package = gitls;
    command = "gitls -version";
    version = "v${version}";
  };

  meta = {
    description = "Tools to enumerate git repository URL";
    homepage = "https://github.com/hahwul/gitls";
    changelog = "https://github.com/hahwul/gitls/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "gitls";
  };
}
