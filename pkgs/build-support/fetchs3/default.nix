{ stdenv, runCommand, awscli }:

{ s3url
, sha256
, region ? "us-east-1"
, credentials ? null # Default to looking at local EC2 metadata service
, executable ? false
, recursiveHash ? false
, postFetch ? null
}:

let
  credentialAttrs = stdenv.lib.optionalAttrs (credentials != null) {
    AWS_ACCESS_KEY_ID = credentials.access_key_id;
    AWS_SECRET_ACCESS_KEY = credentials.secret_access_key;
    AWS_SESSION_TOKEN = credentials.session_token ? null;
  };
in runCommand "foo" ({
  buildInputs = [ awscli ];
  outputHashAlgo = "sha256";
  outputHash = sha256;
  outputHashMode = if recursiveHash then "recursive" else "flat";
} // credentialAttrs) (if postFetch != null then ''
  downloadedFile="$(mktemp)"
  aws s3 cp ${s3url} $downloadedFile
  ${postFetch}
'' else  ''
  aws s3 cp ${s3url} $out
'')
