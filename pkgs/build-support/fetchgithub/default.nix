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
      }@args:
      {
        inherit
          domain
          functionName
          providerName
          ;

        netrcMachineName =
          args.netrcMachineName or (
            if finalAttrs.domain == "github.com" && !finalAttrs.useFetchGit then
              "api.github.com"
            else
              finalAttrs.domain
          );

        derivationArgs = {
          inherit githubBase;
        };
      };
  }
)
