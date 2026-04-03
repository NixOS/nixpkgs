{
  lib,
  repoRevToNameMaybe,
  fetchgit,
}:

let
  inherit (lib)
    assertOneOf
    makeOverridable
    optionalAttrs
    splitString
    ;

  # Hugging Face repositories are always fetched through Git and many model
  # repositories store their weights in Git LFS, so this helper always uses
  # fetchgit and defaults to `fetchLFS = true`. `repoType` only changes the
  # path prefix on huggingface.co.
  repoPrefixes = {
    model = "";
    dataset = "datasets/";
    space = "spaces/";
  };
in

makeOverridable (
  {
    repoId,
    tag ? null,
    rev ? null,
    name ? repoRevToNameMaybe repoId (lib.revOrTag rev tag) "huggingface",
    domain ? "huggingface.co",
    repoType ? "model",
    fetchSubmodules ? false,
    leaveDotGit ? null,
    deepClone ? false,
    fetchLFS ? true,
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

  assert (assertOneOf "repoType" repoType (builtins.attrNames repoPrefixes));

  let
    repoIdParts = splitString "/" repoId;
    validRepoId =
      let
        length = builtins.length repoIdParts;
      in
      length >= 1 && length <= 2 && builtins.all (part: part != "") repoIdParts;
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
      // optionalAttrs (position != null) {
        # to indicate where derivation originates, similar to make-derivation.nix's mkDerivation
        position = "${position.file}:${toString position.line}";
      };
    passthruAttrs = removeAttrs args [
      "repoId"
      "tag"
      "rev"
      "name"
      "domain"
      "repoType"
      "passthru"
      "meta"
    ];
    # Keep the normalized revision visible on the result so callers and tests
    # can reuse the fetcher output without having to re-derive the git ref
    # handling themselves.
    revWithTag = fetchgit.getRevWithTag {
      inherit tag rev;
    };
  in
  assert (
    lib.assertMsg validRepoId "fetchFromHuggingFace requires `repoId` to be in the form `repo` or `owner/repo`."
  );
  fetchgit (
    passthruAttrs
    // {
      inherit
        deepClone
        fetchLFS
        fetchSubmodules
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
    meta = newMeta;
    inherit
      repoId
      tag
      repoType
      ;
  }
  // {
    rev = revWithTag;
  }
)
