{
  lib,
  testers,
  fetchRepoProject,
  ...
}:

{
  # fetch repo by git rev
  manifest-demo-by-rev = testers.invalidateFetcherByDrvHash fetchRepoProject {
    name = "manifest-demo-git-repo-by-rev";
    manifest = "https://github.com/iayanpahwa/manifest-demo.git";
    rev = "6f731a3dd689d58333e53e259cd3b7d2242a4dc8";
    hash = "sha256-cMEvM9lqi8Zl/cFLnTHYv/VVxTzBTHkvhs+jp5U7M/g=";
  };

  # fetch repo by tag
  sel4test-by-tag = testers.invalidateFetcherByDrvHash fetchRepoProject {
    name = "sel4test-by-tag";
    manifest = "https://github.com/seL4/sel4test-manifest.git";
    rev = "refs/tags/16.0.0";
    hash = "sha256-W2vOPWpbcgYPdo+Ife2ddFi3Xpe5Q9jjYqUJd31NQBA=";
  };

  # use different manifest in repo
  sel4test-manifestName = testers.invalidateFetcherByDrvHash fetchRepoProject {
    name = "sel4test-manifestName";
    manifest = "https://github.com/seL4/sel4test-manifest.git";
    manifestName = "master.xml";
    rev = "refs/tags/16.0.0";
    hash = "sha256-H8hxCCa4etdh8+4dSA91mr7BnqvaJsK3Bdik9dx3vSI=";
  };
}
