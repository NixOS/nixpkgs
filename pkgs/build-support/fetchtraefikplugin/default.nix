{
  lib,
  fetchFromGitHub,
}:

lib.makeOverridable (
  {
    plugin,
    owner,
    repo,
    provider ? "github.com", # Most Traefik plugins are developed in GitHub repositories.

    version,
    hash,

    pname ? plugin,
    name ? "${pname}-${version}",
    meta ? { },
  }:
  let
    moduleName = lib.concatStringsSep "/" [
      provider
      owner
      plugin
    ];
  in
  fetchFromGitHub {
    inherit
      hash
      meta
      name
      owner
      repo
      ;
    postFetch = ''
      export tmpdir=$(mktemp -d)
      mv $out/* $out/.* "$tmpdir"
      mkdir -p "$out/src/${moduleName}"
      mv $tmpdir/* $tmpdir/.* "$out/src/${moduleName}"
    '';
    tag = "v${version}";
    passthru = {
      inherit
        moduleName
        plugin
        provider
        owner
        ;
    };
  }
)
