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

        netrcMachineName =
          if finalAttrs.domain == "github.com" && !finalAttrs.useFetchGit then
            "api.github.com"
          else
            finalAttrs.domain;

        derivationArgs = {
          inherit githubBase;
        };
      };
  }
)
