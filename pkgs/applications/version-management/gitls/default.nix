{ lib
, buildGoModule
, gitls
, fetchFromGitHub
, testers
}:

buildGoModule rec {
  pname = "gitls";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "hahwul";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-kLkH/nNidd1QNPKvo7fxZwMhTgd4AVB8Ofw0Wo0z6c0=";
  };

  vendorSha256 = null;

  passthru.tests.version = testers.testVersion {
    package = gitls;
    command = "gitls -version";
    version = "v${version}";
  };

  meta = with lib; {
    description = "Tools to enumerate git repository URL";
    homepage = "https://github.com/hahwul/gitls";
    changelog = "https://github.com/hahwul/gitls/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
