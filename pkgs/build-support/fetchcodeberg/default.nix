{
  lib,
  fetchFromGitea,
}:
lib.makeOverridable (
  lib.extendMkDerivation {
    constructDrv = fetchFromGitea;
    extendDrvArgs =
      finalAttrs:
      {
        domain ? "codeberg.org",
        # Keep providerName as "Gitea" to have unified netrcImpureVars.
        functionName ? "fetchFromCodeberg",
        ...
      }:
      {
        inherit
          domain
          functionName
          ;
      };
  }
)
