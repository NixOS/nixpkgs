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
      let
        baseUrl = "https://${finalAttrs.domain}/${finalAttrs.owner}/${finalAttrs.repo}";
        revWithTag = finalAttrs.rev;
      in
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

        archiveUrl =
          # Use the API endpoint for private repos, as the archive URI doesn't
          # support access with GitHub's fine-grained access tokens.
          #
          # Use the archive URI for non-private repos, as the API endpoint has
          # relatively restrictive rate limits for unauthenticated users.
          if finalAttrs.private then
            let
              endpoint = "/repos/${finalAttrs.owner}/${finalAttrs.repo}/tarball/${revWithTag}";
            in
            if finalAttrs.domain == "github.com" then
              "https://api.github.com${endpoint}"
            else
              "https://${finalAttrs.domain}/api/v3${endpoint}"
          else
            "${baseUrl}/archive/${revWithTag}.tar.gz";

        browsableUrl = baseUrl;

        derivationArgs = {
          inherit githubBase;
        };
      };
  }
)
