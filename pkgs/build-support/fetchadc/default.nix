{ stdenv, curl, adc_user, adc_pass }:

let
  impureEnvVars = [
    # We borrow these environment variables from the caller to allow
    # easy proxy configuration.  This is impure, but a fixed-output
    # derivation like fetchurl is allowed to do so since its result is
    # by definition pure.
    "http_proxy" "https_proxy" "ftp_proxy" "all_proxy" "no_proxy"
  ];
in

{ # Path to fetch.
  path

  # Hash of the downloaded file
, sha256

, # Additional curl options needed for the download to succeed.
  curlOpts ? ""

, # Name of the file.  If empty, use the basename of `path'.
  name ? ""
}:

stdenv.mkDerivation {
  url = "https://developer.apple.com/downloads/download.action?path=${path}";

  name    = if name != "" then name else baseNameOf path;
  builder = ./builder.sh;

  buildInputs = [ curl ];

  meta = {
    # Password-guarded files from ADC are certainly unfree, as far as we're concerned!
    license = stdenv.lib.licenses.unfree;
  };

  outputHashAlgo = "sha256";
  outputHash     =  sha256;
  outputHashMode = "flat";

  inherit curlOpts adc_user adc_pass;

  preferLocalBuild = true;
}
