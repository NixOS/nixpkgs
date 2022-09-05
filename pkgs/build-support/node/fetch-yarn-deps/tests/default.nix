{ testers, fetchYarnDeps, ... }:

{
  simple = testers.invalidateFetcherByDrvHash fetchYarnDeps {
    yarnLock = ./simple.lock;
    sha256 = "sha256-Erdkw2E8wWT09jFNLXGkrdwKl0HuSZWnUDJUrV95vSE=";
  };
  gitDep = testers.invalidateFetcherByDrvHash fetchYarnDeps {
    yarnLock = ./git.lock;
    sha256 = "sha256-lAqN4LpoE+jgsQO1nDtuORwcVEO7ogEV53jCu2jFJUI=";
  };
  githubDep = testers.invalidateFetcherByDrvHash fetchYarnDeps {
    yarnLock = ./github.lock;
    sha256 = "sha256-Tsfgyjxz8x6gNmfN0xR7G/NQNoEs4svxRN/N+26vfJU=";
  };
}
