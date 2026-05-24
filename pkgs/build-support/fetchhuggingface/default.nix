{
  lib,
  repoRevToNameMaybe,
  fetchgit,
}:

let
  repoPrefixes = {
    model = "";
    dataset = "datasets/";
    space = "spaces/";
  };
in

lib.makeOverridable (
  {
    repoId,
    tag ? null,
    rev ? null,
    name ? repoRevToNameMaybe repoId (lib.revOrTag rev tag) "huggingface",
    domain ? "huggingface.co",
    repoType ? "model",
    branchName ? null,
    deepClone ? false,
    fetchLFS ? true,
    fetchSubmodules ? false,
    fetchTags ? false,
    leaveDotGit ? null,
    rootDir ? "",
    sparseCheckout ? null,
    passthru ? { },
    meta ? { },
    ... # For hash agility and additional fetchgit arguments
  }@args:

  assert (
    lib.assertMsg (lib.xor (tag == null) (
      rev == null
    )) "fetchFromHuggingFace requires one of either `rev` or `tag` to be provided (not both)."
  );

  assert (lib.assertOneOf "repoType" repoType (builtins.attrNames repoPrefixes));

  let
    position = (
      if args.meta.description or null != null then
        builtins.unsafeGetAttrPos "description" args.meta
      else if tag != null then
        builtins.unsafeGetAttrPos "tag" args
      else
        builtins.unsafeGetAttrPos "rev" args
    );
    baseUrl = "https://${domain}/${repoPrefixes.${repoType}}${repoId}";
    gitRepoUrl = "${baseUrl}.git";
    newMeta =
      meta
      // {
        homepage = meta.homepage or baseUrl;
      }
      // lib.optionalAttrs (position != null) {
        # to indicate where derivation originates, similar to make-derivation.nix's mkDerivation
        position = "${position.file}:${toString position.line}";
      };
  in
  assert (
    lib.assertMsg (
      builtins.match "[^/]+(/[^/]+)?" repoId != null
    ) "fetchFromHuggingFace requires `repoId` to be in the form `repo` or `owner/repo`."
  );
  fetchgit (
    removeAttrs args [
      "repoId"
      "domain"
      "repoType"
    ]
    // {
      inherit
        branchName
        deepClone
        fetchLFS
        fetchSubmodules
        fetchTags
        leaveDotGit
        name
        rootDir
        sparseCheckout
        tag
        rev
        ;
      url = gitRepoUrl;
      meta = newMeta;
      passthru = {
        inherit gitRepoUrl;
      }
      // passthru;
    }
  )
  // {
    inherit
      repoId
      repoType
      ;
  }
)
