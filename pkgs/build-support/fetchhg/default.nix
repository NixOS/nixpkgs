{
  lib,
  stdenvNoCC,
  mercurial,
}:

lib.extendMkDerivation {
  constructDrv = stdenvNoCC.mkDerivation;

  extendDrvArgs =
    finalAttrs:
{
  name ? null,
  url,
  rev ? null,
  sha256 ? null,
  hash ? null,
  fetchSubrepos ? false,
  preferLocalBuild ? true,
}:
  # TODO: statically check if mercurial as the https support if the url starts with https.
  {
    name = "hg-archive" + (lib.optionalString (name != null) "-${name}");
    builder = ./builder.sh;
    nativeBuildInputs = [ mercurial ];

    impureEnvVars = lib.fetchers.proxyImpureEnvVars;

    subrepoClause = lib.optionalString fetchSubrepos "S";

    outputHashAlgo = if hash != null && hash != "" then null else "sha256";
    outputHashMode = "recursive";
    outputHash =
      lib.throwIf
        (hash != null && sha256 != null)
        "Only one of sha256 or hash can be set"
        (
          if hash != null then
            hash
          else if sha256 != null then
            sha256
          else
            ""
        );

    inherit url rev;
    inherit preferLocalBuild;
  };

  # No ellipsis
  inheritFunctionArgs = false;
}
