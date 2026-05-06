{
  lib,
  repoRevToNameMaybe,
  fetchgit,
  fetchzip,
}:
lib.makeOverridable (
  {
    owner,
    repo,
    rev ? null,
    tag ? null,
    name ? repoRevToNameMaybe repo (lib.revOrTag rev tag) "forgejo",
    domain,
    fetchSubmodules ? false,
    leaveDotGit ? false,
    deepClone ? false,
    forceFetchGit ? false,
    sparseCheckout ? [ ],
    private ? false,
    varPrefix ? null,
    meta ? { },
    ...
  }@args:
  assert (
    lib.assertMsg (lib.xor (tag == null) (
      rev == null
    )) "fetchFromForgejo requires one of either `rev` or `tag` to be provided (not both)."
  );
  let
    revOrTag = if tag != null then tag else rev;
    baseUrl = "https://${domain}/${owner}/${repo}";
    gitRepoUrl = "${baseUrl}.git";

    useFetchGit =
      fetchSubmodules || leaveDotGit || deepClone || forceFetchGit || (sparseCheckout != [ ]);

    fetcher = if useFetchGit then fetchgit else fetchzip;

    varBase = "NIX${lib.optionalString (varPrefix != null) "_${varPrefix}"}_FORGEJO_PRIVATE_";

    privateAttrs = lib.optionalAttrs private {
      netrcPhase = ''
        if [ -z "''$${varBase}TOKEN" ]; then
          echo "Error: Private fetchFromForgejo requires the nix building process (nix-daemon in multi user mode) to have the ${varBase}TOKEN env var set." >&2
          exit 1
        fi
      ''
      + ''
        cat > netrc <<EOF
        machine ${domain}
                login token
                password ''$${varBase}TOKEN
        EOF
      '';
      netrcImpureEnvVars = [ "${varBase}TOKEN" ];
    };

    passthruAttrs = removeAttrs args [
      "owner"
      "repo"
      "rev"
      "tag"
      "domain"
      "fetchSubmodules"
      "forceFetchGit"
      "private"
      "varPrefix"
      "leaveDotGit"
      "deepClone"
      "meta"
    ];

    position =
      if args.meta.description or null != null then
        builtins.unsafeGetAttrPos "description" args.meta
      else if tag != null then
        builtins.unsafeGetAttrPos "tag" args
      else
        builtins.unsafeGetAttrPos "rev" args;

    newMeta =
      meta
      // {
        homepage = meta.homepage or baseUrl;
      }
      // lib.optionalAttrs (position != null) {
        position = "${position.file}:${toString position.line}";
      };

    fetcherArgs =
      (
        if useFetchGit then
          {
            url = gitRepoUrl;
            inherit
              rev
              tag
              deepClone
              fetchSubmodules
              sparseCheckout
              leaveDotGit
              ;
          }
        else
          {
            url =
              if private then
                "https://${domain}/api/v1/repos/${owner}/${repo}/archive/${revOrTag}.tar.gz"
              else
                "${baseUrl}/archive/${revOrTag}.tar.gz";
            extension = "tar.gz";
            passthru = {
              inherit gitRepoUrl;
            };
          }
      )
      // privateAttrs
      // passthruAttrs
      // {
        inherit name;
      };
  in
  fetcher fetcherArgs
  // {
    meta = newMeta;
    inherit owner repo tag;
    rev = revOrTag;
  }
)
