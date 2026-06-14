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
        domain ? finalAttrs.githubBase,
        functionName ? "fetchFrom${finalAttrs.providerName}",
        githubBase ? "github.com",
        providerName ? "GitHub",
        ...
      }:
      {
        inherit
          domain
          functionName
          providerName
          ;
        derivationArgs = {
          inherit githubBase;
        };
      };
  }
)
