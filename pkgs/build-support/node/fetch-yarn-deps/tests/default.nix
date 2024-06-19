{ testers, fetchYarnDeps, ... }:

{
  file = testers.invalidateFetcherByDrvHash fetchYarnDeps {
    yarnLock = ./file.lock;
    sha256 = "sha256-BPuyQVCbdpFL/iRhmarwWAmWO2NodlVCOY9JU+4pfa4=";
  };
  simple = testers.invalidateFetcherByDrvHash fetchYarnDeps {
    yarnLock = ./simple.lock;
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
  };
}
