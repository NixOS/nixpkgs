{ testers, fetchYarnDeps, ... }:

{
  simple = testers.invalidateFetcherByDrvHash fetchYarnDeps {
    yarnLock = ./simple.lock;
<<<<<<< HEAD
    sha256 = "sha256-FRrt8BixleILmFB2ZV8RgPNLqgS+dlH5nWoPgeaaNQ8=";
  };
  gitDep = testers.invalidateFetcherByDrvHash fetchYarnDeps {
    yarnLock = ./git.lock;
    sha256 = "sha256-f90IiEzHDiBdswWewRBHcJfqqpPipaMg8N0DVLq2e8Q=";
  };
  githubDep = testers.invalidateFetcherByDrvHash fetchYarnDeps {
    yarnLock = ./github.lock;
    sha256 = "sha256-DIKrhDKoqm7tHZmcuh9eK9VTqp6BxeW0zqDUpY4F57A=";
  };
  gitUrlDep = testers.invalidateFetcherByDrvHash fetchYarnDeps {
    yarnLock = ./giturl.lock;
    sha256 = "sha256-VPnyqN6lePQZGXwR7VhbFnP7/0/LB621RZwT1F+KzVQ=";
=======
    sha256 = "sha256-Erdkw2E8wWT09jFNLXGkrdwKl0HuSZWnUDJUrV95vSE=";
  };
  gitDep = testers.invalidateFetcherByDrvHash fetchYarnDeps {
    yarnLock = ./git.lock;
    sha256 = "sha256-lAqN4LpoE+jgsQO1nDtuORwcVEO7ogEV53jCu2jFJUI=";
  };
  githubDep = testers.invalidateFetcherByDrvHash fetchYarnDeps {
    yarnLock = ./github.lock;
    sha256 = "sha256-Tsfgyjxz8x6gNmfN0xR7G/NQNoEs4svxRN/N+26vfJU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
