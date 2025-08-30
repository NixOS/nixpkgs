{
  lib,
  fetchzip,
  traefik,
}:

lib.extendMkDerivation {
  constructDrv = fetchzip;
  extendDrvArgs =
    finalAttrs:
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
    {
      inherit
        hash
        name
        ;

      url = "https://plugins.traefik.io/public/download/${moduleName}/${version}";
      postFetch = ''
        export tmpdir=$(mktemp -d)
        mv -R * .* $tmpdir
        mkdir -p $out/src/${moduleName}
        mv -R $tmpdir/* $tmpdir/.* $out/src/${moduleName}
      '';

      passthru = {
        inherit
          moduleName
          plugin
          provider
          owner
          ;
      };

      meta = {
        homepage = "https://plugins.traefik.io/plugins";
        inherit (traefik) platforms;
      }
      // meta;
    };
}
