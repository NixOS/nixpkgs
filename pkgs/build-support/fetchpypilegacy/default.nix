# Fetch from PyPi legacy API as documented in https://warehouse.pypa.io/api-reference/legacy.html
{ runCommand
, lib
, python3
}:
{
  # package name
  pname,
  # Package index
  url ? null,
  # Multiple package indices to consider
  urls ? [ ],
  # filename including extension
  file,
  # SRI hash
  hash,
}:
let
  urls' = urls ++ lib.optional (url != null) url;

  pathParts = lib.filter ({ prefix, path }: "NETRC" == prefix) builtins.nixPath;
  netrc_file =
    if (pathParts != [ ])
    then (lib.head pathParts).path
    else "";

in
# Assert that we have at least one URL
assert urls' != [ ]; runCommand file
  {
    nativeBuildInputs = [ python3 ];
    impureEnvVars = lib.fetchers.proxyImpureEnvVars;
    outputHashMode = "flat";
    outputHashAlgo = null;
    outputHash = hash;
    NETRC = netrc_file;
    passthru = {
      urls = urls';
    };
  }
  ''
    python ${./fetch-legacy.py} ${lib.concatStringsSep " " (map (url: "--url ${lib.escapeShellArg url}") urls')} --pname ${pname} --filename ${file}
    mv ${file} $out
  ''
