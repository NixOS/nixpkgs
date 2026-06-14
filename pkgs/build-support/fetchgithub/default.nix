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
        meta ? { },
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
        meta = {
          identifiers = {
            purlParts =
              if finalAttrs.domain == "github.com" then
                {
                  type = "github";
                  # https://github.com/package-url/purl-spec/blob/18fd3e395dda53c00bc8b11fe481666dc7b3807a/types-doc/github-definition.md
                  spec = "${finalAttrs.owner}/${finalAttrs.repo}@${(lib.revOrTag finalAttrs.revCustom finalAttrs.tag)}";
                }
              else
                {
                  type = "generic";
                  # https://github.com/package-url/purl-spec/blob/18fd3e395dda53c00bc8b11fe481666dc7b3807a/types-doc/generic-definition.md
                  spec = "${finalAttrs.repo}?vcs_url=https://${finalAttrs.domain}/${finalAttrs.owner}/${finalAttrs.repo}@${(lib.revOrTag finalAttrs.revCustom finalAttrs.tag)}";
                };
          }
          // meta.identifiers or { };
        };
      };
  }
)
