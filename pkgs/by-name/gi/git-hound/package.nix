{
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "git-hound";
  version = "3.2";

  src = fetchFromGitHub {
    owner = "tillson";
    repo = "git-hound";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zd9ttx3U2XtXhsqe3sT8oCUeFmFg5k519TPntCFf+0s=";
  };

  # tests fail outside of nix
  doCheck = false;

  vendorHash = "sha256-AgVNfYLs1myhOjIgylcchWKbFwW9qSsYqzqRxRHvKQ0=";

  meta = {
    description = "Reconnaissance tool for GitHub code search";
    longDescription = ''
      GitHound pinpoints exposed API keys and other sensitive information
      across all of GitHub using pattern matching, commit history searching,
      and a unique result scoring system.
    '';
    homepage = "https://github.com/tillson/git-hound";
    changelog = "https://github.com/tillson/git-hound/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "git-hound";
  };
})
