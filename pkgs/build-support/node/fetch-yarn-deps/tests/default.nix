{
  stdenvNoCC,
  testers,
  fetchYarnDeps,
  ...
}:

let
  makeTestSrc =
    { name, src }:
    stdenvNoCC.mkDerivation {
      name = "${name}-src";

      inherit src;

      buildCommand = ''
        mkdir -p $out
        cp $src $out/yarn.lock
      '';
    };

  makeTest =
    {
      name,
      src,
      hash,
      forceEmptyCache ? false,
      npmRegistryOverridesString ? "{}",
    }:
    testers.invalidateFetcherByDrvHash fetchYarnDeps {
      inherit
        name
        hash
        forceEmptyCache
        npmRegistryOverridesString
        ;

      src = makeTestSrc { inherit name src; };
    };
in
{
  file = makeTest {
    name = "file";
    src = ./file.lock;
    hash = "sha256-BPuyQVCbdpFL/iRhmarwWAmWO2NodlVCOY9JU+4pfa4=";
    forceEmptyCache = true;
  };
  simple = makeTest {
    name = "simple";
    src = ./simple.lock;
    hash = "sha256-FRrt8BixleILmFB2ZV8RgPNLqgS+dlH5nWoPgeaaNQ8=";
  };
  gitDep = makeTest {
    name = "gitDep";
    src = ./git.lock;
    hash = "sha256-f90IiEzHDiBdswWewRBHcJfqqpPipaMg8N0DVLq2e8Q=";
  };
  githubDep = makeTest {
    name = "githubDep";
    src = ./github.lock;
    hash = "sha256-DIKrhDKoqm7tHZmcuh9eK9VTqp6BxeW0zqDUpY4F57A=";
  };
  githubReleaseDep = makeTest {
    name = "githubReleaseDep";
    src = ./github-release.lock;
    hash = "sha256-g+y/H6k8LZ+IjWvkkwV7JhKQH1ycfeqzsIonNv4fDq8=";
  };
  gitUrlDep = makeTest {
    name = "gitUrlDep";
    src = ./giturl.lock;
    hash = "sha256-VPnyqN6lePQZGXwR7VhbFnP7/0/LB621RZwT1F+KzVQ=";
  };
}
