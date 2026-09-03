{
  lib,
  fetchFromGitProvider,
}:

let
  nullIfNot = condition: if !condition then v: null else v: v;
in
lib.makeOverridable (
  lib.extendMkDerivation {
    constructDrv = fetchFromGitProvider;

    excludeDrvArgNames = [
      "protocol"
      "group"
    ];

    extendDrvArgs =
      finalAttrs:
      let
        slug = lib.concatStringsSep "/" (
          (lib.optional (finalAttrs.group != null) finalAttrs.group)
          ++ [
            finalAttrs.owner
            finalAttrs.repo
          ]
        );
        revWithTag = finalAttrs.rev;
        escapedSlug = lib.replaceStrings [ "." "/" ] [ "%2E" "%2F" ] slug;
        escapedRevWithTag = lib.replaceStrings [ "+" "%" "/" ] [ "%2B" "%25" "%2F" ] revWithTag;
      in
      {
        providerName ? "GitLab",
        functionName ? "fetchFrom${finalAttrs.providerName}",
        protocol ? "https",
        domain ? "gitlab.com",
        group ? null,
        browsableUrl ? "${finalAttrs.protocol}://${finalAttrs.domain}/${slug}/",
        archiveUrl ? "${finalAttrs.protocol}://${finalAttrs.domain}/api/v4/projects/${escapedSlug}/repository/archive.tar.gz?sha=${escapedRevWithTag}",
        gitRepoUrl ? "${finalAttrs.protocol}://${finalAttrs.domain}/${slug}.git",
        ...
      }@args:
      {
        inherit
          archiveUrl
          browsableUrl
          domain
          functionName
          gitRepoUrl
          providerName
          ;

        netrcPhase =
          args.netrcPhase or (nullIfNot finalAttrs.private (
            lib.throwIfNot (protocol == "https") "private token login is only supported for https" ''
              if [ -z "''$${finalAttrs.varBase}USERNAME" -o -z "''$${finalAttrs.varBase}PASSWORD" ]; then
                echo "Error: Private ${functionName} requires the nix building process (nix-daemon in multi user mode) to have the ${finalAttrs.varBase}USERNAME and ${finalAttrs.varBase}PASSWORD env vars set." >&2
                exit 1
              fi
            ''
            + (
              if finalAttrs.useFetchGit then
                # GitLab supports HTTP Basic Authentication only when Git is used:
                # https://docs.gitlab.com/ee/user/project/settings/project_access_tokens.html#project-access-tokens
                ''
                  cat > netrc <<EOF
                  machine $netrcMachineName
                          login ''$${finalAttrs.varBase}USERNAME
                          password ''$${finalAttrs.varBase}PASSWORD
                  EOF
                ''
              else
                # Access via the GitLab API requires a custom header and does not work
                # with HTTP Basic Authentication:
                # https://docs.gitlab.com/ee/api/#personalprojectgroup-access-tokens
                ''
                  # needed because fetchurl always sets --netrc-file if a netrcPhase is present
                  touch netrc

                  cat > private-token <<EOF
                  PRIVATE-TOKEN: ''$${finalAttrs.varBase}PASSWORD
                  EOF
                  curlOpts="$curlOpts --header @./private-token"
                ''
            )
          ));

        derivationArgs = {
          inherit
            group
            protocol
            ;
        };
      };
  }
)
