{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "cz-cli";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "commitizen";
    repo = "cz-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-4kyGxidE8dzkHL0oPv/XxDxQ3qlEE6TKSgj+1g9uvJM=";
  };

  npmDepsHash = "sha256-zQ0T/1khnn+CXm/3yc9nANL0ROEEE03U5fV57btEmPg=";

  meta = with lib; {
    description = "The commitizen command line utility";
    homepage = "https://commitizen.github.io/cz-cli";
    changelog = "https://github.com/commitizen/cz-cli/releases/tag/v${version}";
    maintainers = with maintainers; [
      freezeboy
      natsukium
    ];
    license = licenses.mit;
  };
}
