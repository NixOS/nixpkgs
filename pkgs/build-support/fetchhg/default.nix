{
  lib,
  stdenvNoCC,
  mercurial,
}:

lib.extendMkDerivation {
  constructDrv = stdenvNoCC.mkDerivation;
  excludeDrvArgNames = [ "name" ];
  extendDrvArgs = (
    finalAttrs:
    args@{
      url,
      name ? null,
      sha256 ? null,
      hash ? null,
      fetchSubrepos ? false,
      ...
    }:
    if hash != null && sha256 != null then
      throw "Only one of sha256 or hash can be set"
    else
      {
        name = "hg-archive" + (lib.optionalString (name != null) "-${name}");
        builder = ./builder.sh;
        nativeBuildInputs = [ mercurial ];

        impureEnvVars = lib.fetchers.proxyImpureEnvVars;

        subrepoClause = lib.optionalString fetchSubrepos "S";

        insecureArgStr = lib.optionalString (!(lib.hasPrefix "https" url)) "--insecure";

        outputHashAlgo = if hash != null then null else "sha256";
        outputHashMode = "recursive";
        outputHash = args.hash or args.sha256 or lib.fakeSha256;
      }
  );
}
