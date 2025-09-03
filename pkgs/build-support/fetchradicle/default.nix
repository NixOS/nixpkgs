{ lib, fetchgit }:

lib.makeOverridable (
  {
    seed,
    repo,
    node ? null,
    rev ? null,
    tag ? null,
    ...
  }@args:

  assert lib.assertMsg (lib.xor (tag != null) (
    rev != null
  )) "fetchFromRadicle requires one of either `rev` or `tag` to be provided (not both).";

  let
    namespacePrefix = lib.optionalString (node != null) "refs/namespaces/${node}/";
    rev' = if tag != null then "refs/tags/${tag}" else rev;
  in

  fetchgit (
    {
      url = "https://${seed}/${repo}.git";
      rev = "${namespacePrefix}${rev'}";
    }
    // removeAttrs args [
      "seed"
      "repo"
      "node"
      "rev"
      "tag"
    ]
  )
  // {
    inherit
      seed
      repo
      node
      rev
      tag
      ;
  }
)
