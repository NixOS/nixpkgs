{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "cz-cli";
  version = "4.3.2";

  src = fetchFromGitHub {
    owner = "commitizen";
    repo = "cz-cli";
    tag = "v${version}";
    hash = "sha256-+MBFO3sisxV/4iddZTsfJW8QARZ+JlWK5ao3KNJ3zSA=";
  };

  npmDepsHash = "sha256-6UpTaMqd7T17gx4yJowcWJMgKmFeq2r2yckrx1OpTCc=";

  meta = {
    description = "Commitizen command line utility";
    homepage = "https://commitizen.github.io/cz-cli";
    changelog = "https://github.com/commitizen/cz-cli/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ natsukium ];
    license = lib.licenses.mit;
  };
}
