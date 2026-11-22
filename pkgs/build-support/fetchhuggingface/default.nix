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
    backend ? "xet",
    branchName ? null,
    deepClone ? false,
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
  assert (
    lib.assertOneOf "backend" backend [
      "lfs"
      "xet"
    ]
  );

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
    backendFetcher = builtins.getAttr backend {
      lfs = fetchgit;
      xet = throw "fetchFromHuggingFace: the Xet backend is not implemented yet";
    };
  in
  assert (
    lib.assertMsg (
      builtins.match "[^/]+(/[^/]+)?" repoId != null
    ) "fetchFromHuggingFace requires `repoId` to be in the form `repo` or `owner/repo`."
  );
  backendFetcher (
    removeAttrs args [
      "backend"
      "domain"
      "repoId"
      "repoType"
    ]
    // {
      inherit
        branchName
        deepClone
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
      fetchLFS = true;
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
