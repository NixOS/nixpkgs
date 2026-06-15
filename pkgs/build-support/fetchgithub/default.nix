{
  lib,
  fetchFromGitProvider,
}:
lib.makeOverridable (
  lib.extendMkDerivation {
    constructDrv = fetchFromGitProvider;
    excludeDrvArgNames = [
      "apiBaseUrl"
      "apiVersion"
      "githubBase"
    ];
    extendDrvArgs =
      finalAttrs:
      {
        providerName ? "GitHub",
        functionName ? "fetchFrom${finalAttrs.providerName}",
        githubBase ? "github.com",
        domain ? finalAttrs.githubBase,
        apiVersion ? 3,
        apiBaseUrl ?
          "https://"
          + (
            if finalAttrs.domain == "github.com" then
              "api.github.com"
            else
              finalAttrs.domain + "/api/v" + toString finalAttrs.apiVersion
          ),
        meta ? { },
        ...
      }@args:
      let
        baseUrl = "https://${finalAttrs.domain}/${finalAttrs.owner}/${finalAttrs.repo}";
        revWithTag = finalAttrs.rev;
      in
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

        archiveUrl =
          args.archiveUrl or (
            # Use the API endpoint for private repos, as the archive URI doesn't
            # support access with GitHub's fine-grained access tokens.
            #
            # Use the archive URI for non-private repos, as the API endpoint has
            # relatively restrictive rate limits for unauthenticated users.
            if finalAttrs.private then
              "${finalAttrs.apiBaseUrl}/repos/${finalAttrs.owner}/${finalAttrs.repo}/tarball/${revWithTag}"
            else
              "${baseUrl}/archive/${revWithTag}.tar.gz"
          );

        browsableUrl = args.browsableUrl or baseUrl;

        derivationArgs = {
          inherit
            apiBaseUrl
            apiVersion
            githubBase
            ;
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
