{ lib, runCommand, awscli }:

{ s3url
, name ? builtins.baseNameOf s3url
, sha256
, region ? "us-east-1"
, credentials ? null # Default to looking at local EC2 metadata service
, recursiveHash ? false
, postFetch ? null
}:

let
  mkCredentials = { access_key_id, secret_access_key, session_token ? null }: {
    AWS_ACCESS_KEY_ID = access_key_id;
    AWS_SECRET_ACCESS_KEY = secret_access_key;
    AWS_SESSION_TOKEN = session_token;
  };

  credentialAttrs = lib.optionalAttrs (credentials != null) (mkCredentials credentials);
in runCommand name ({
  nativeBuildInputs = [ awscli ];

  outputHashAlgo = "sha256";
  outputHash = sha256;
  outputHashMode = if recursiveHash then "recursive" else "flat";

  preferLocalBuild = true;

  AWS_DEFAULT_REGION = region;
} // credentialAttrs) (if postFetch != null then ''
  downloadedFile="$(mktemp)"
  aws s3 cp ${s3url} $downloadedFile
  ${postFetch}
'' else  ''
  aws s3 cp ${s3url} $out
'')
