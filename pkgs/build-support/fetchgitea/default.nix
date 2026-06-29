# Gitea's URLs are largely compatible with GitHub

{
  lib,
  fetchFromGitHub,
}:

lib.makeOverridable (
  lib.extendMkDerivation {
    constructDrv = fetchFromGitHub;
    extendDrvArgs =
      finalAttrs:
      {
        providerName ? "Gitea",
        # Gitea: https://docs.gitea.com/api/#tag/repository/operation/repoGetArchive
        # Forgejo: https://code.forgejo.org/api/swagger#/repository/repoGetArchive
        # Codeberg: https://codeberg.org/api/swagger#/repository/repoGetArchive
        apiVersion ? 1,
        ...
      }:
      {
        inherit
          apiVersion
          providerName
          ;
      };
    transformDrv =
      drv:
      drv.overrideAttrs {
        githubBase = null;
      };
  }
)
