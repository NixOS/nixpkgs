{
  lib,
  fetchFromGitProvider,
}:
lib.makeOverridable (
  lib.extendMkDerivation {
    constructDrv = fetchFromGitProvider;
    excludeDrvArgNames = [
      "githubBase"
    ];
    extendDrvArgs =
      finalAttrs:
      {
        githubBase ? "github.com",
        ...
      }:
      {
        domain = finalAttrs.githubBase;
        functionName = "fetchFromGitHub";
        derivationArgs = {
          inherit githubBase;
        };
      };
  }
)
