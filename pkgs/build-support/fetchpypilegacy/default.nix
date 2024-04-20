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
  # allow overriding the derivation name
  name ? null,
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
  ({
    nativeBuildInputs = [ python3 ];
    impureEnvVars = lib.fetchers.proxyImpureEnvVars;
    outputHashMode = "flat";
    # if hash is empty select a default algo to let nix propose the actual hash.
    outputHashAlgo = if hash == "" then "sha256" else null;
    outputHash = hash;
    NETRC = netrc_file;
  }
  // (lib.optionalAttrs (name != null) {inherit name;}))
  ''
    python ${./fetch-legacy.py} ${lib.concatStringsSep " " (map (url: "--url ${lib.escapeShellArg url}") urls')} --pname ${pname} --filename ${file}
    mv ${file} $out
  ''
