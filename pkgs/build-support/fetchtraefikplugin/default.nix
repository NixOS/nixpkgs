{
  lib,
  fetchzip,
  traefik,
}:

lib.makeOverridable (
  {
    plugin,
    owner,
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
  fetchzip {
    inherit
      hash
      name
      ;

    # Every single published Traefik plugin starts its version string with 'v'.
    url = "https://plugins.traefik.io/public/download/${moduleName}/v${version}";
    extension = "zip";
    stripRoot = false;
    postFetch = ''
      export tmpdir=$(mktemp -d)
      mv $out/${moduleName}@v${version}/* $out/${moduleName}@v${version}/.* $tmpdir
      rm -rf $out/${provider}
      mkdir -p "$out/src/${moduleName}"
      mv -t "$out/src/${moduleName}" $tmpdir/* $tmpdir/.*
    '';

    passthru = {
      inherit
        moduleName
        plugin
        provider
        owner
        ;
      _isTraefikPlugin = true;
    };

    meta = {
      homepage = "https://plugins.traefik.io/plugins";
      inherit (traefik.meta) platforms;
    }
    // meta;
  }
)
