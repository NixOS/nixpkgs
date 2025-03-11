{ fetchzip, lib }:

lib.makeOverridable (
  {
    url,
    rev ? null,
    tag ? null,
    name ? "source",
    ...
  }@args:

  assert (
    lib.assertMsg (lib.xor (tag == null) (
      rev == null
    )) "fetchFromGitiles requires one of either `rev` or `tag` to be provided (not both)."
  );

  let
    realrev = (if tag != null then "refs/tags/" + tag else rev);
  in

  fetchzip (
    {
      inherit name;
      url = "${url}/+archive/${realrev}.tar.gz";
      stripRoot = false;
      meta.homepage = url;
    }
    // removeAttrs args [
      "url"
      "tag"
      "rev"
    ]
  )
  // {
    inherit rev tag;
  }
)
