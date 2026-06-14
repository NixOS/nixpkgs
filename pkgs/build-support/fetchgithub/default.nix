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
        functionName ? "fetchFromGitHub",
        githubBase ? "github.com",
        ...
      }:
      {
        inherit
          domain
          functionName
          ;
        derivationArgs = {
          inherit githubBase;
        };
      };
  }
)
