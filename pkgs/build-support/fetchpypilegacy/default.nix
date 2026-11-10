# Fetch from PyPi legacy API as documented in https://warehouse.pypa.io/api-reference/legacy.html
{
  runCommand,
  lib,
  python3,
  cacert,
}@pkgs:
let
  inherit (lib)
    optionalAttrs
    fetchers
    optional
    inPureEvalMode
    filter
    head
    concatStringsSep
    escapeShellArg
    ;

  impureEnvVars = fetchers.proxyImpureEnvVars ++ optional inPureEvalMode "NETRC";
in
lib.makeOverridable (
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
    # allow overriding cacert using src.override { cacert = cacert.override { extraCertificateFiles = [ ./path/to/cert.pem ]; }; }
    cacert ? pkgs.cacert,
  }:
  let
    urls' = urls ++ optional (url != null) url;

    pathParts = filter ({ prefix, path }: "NETRC" == prefix) builtins.nixPath;
    netrc_file = if (pathParts != [ ]) then (head pathParts).path else "";

  in
  # Assert that we have at least one URL
  assert urls' != [ ];
  runCommand file
    (
      {
        nativeBuildInputs = [
          python3
          cacert
        ];
        inherit impureEnvVars;
        outputHashMode = "flat";
        # if hash is empty select a default algo to let nix propose the actual hash.
        outputHashAlgo = if hash == "" then "sha256" else null;
        outputHash = hash;
      }
      // optionalAttrs (name != null) { inherit name; }
      // optionalAttrs (!inPureEvalMode) { env.NETRC = netrc_file; }
    )
    ''
      python ${./fetch-legacy.py} ${
        concatStringsSep " " (map (url: "--url ${escapeShellArg url}") urls')
      } --pname ${pname} --filename ${file}
      mv ${file} $out
    ''
)
