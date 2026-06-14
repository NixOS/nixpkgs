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
        providerName ? "GitHub",
        functionName ? "fetchFrom${finalAttrs.providerName}",
        githubBase ? "github.com",
        ...
      }:
      {
        inherit
          providerName
          functionName
          ;
        domain = finalAttrs.githubBase;
        derivationArgs = {
          inherit githubBase;
        };
      };
  }
)
