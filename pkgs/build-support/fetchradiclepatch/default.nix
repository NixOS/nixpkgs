{
  fetchFromRadicle,
  jq,
  lib,
}:

lib.makeOverridable (
  {
    revision,
    postFetch ? "",
    nativeBuildInputs ? [ ],
    ...
  }@args:

  assert lib.assertMsg (
    !args ? rev && !args ? tag
  ) "fetchRadiclePatch does not accept `rev` or `tag` arguments.";

  fetchFromRadicle (
    {
      nativeBuildInputs = [ jq ] ++ nativeBuildInputs;
      rev = revision;
      leaveDotGit = true;
      postFetch = ''
        { read -r head; read -r base; } < <(jq -r '.oid, .base' $out/0)
        git -C $out fetch --depth=1 "$url" "$base" "$head"
        git -C $out diff "$base" "$head" > patch
        rm -r $out
        mv patch $out
        ${postFetch}
      '';
    }
    // removeAttrs args [
      "revision"
      "postFetch"
      "nativeBuildInputs"
      "leaveDotGit"
    ]
  )
  // {
    inherit revision;
  }
)
