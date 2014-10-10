{ stdenv, cacert, cargo}:
{ name, src, sha256 }:

stdenv.mkDerivation {
  name = "${name}-fetch";
  buildInputs = [ cargo ];
  builder = ./fetch-builder.sh;
  fetcher = ./nix-prefetch-cargo;
  inherit src;

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  SSL_CERT_FILE = "${cacert}/etc/ca-bundle.crt";

  impureEnvVars = [ "http_proxy" "https_proxy" "ftp_proxy" "all_proxy" "no_proxy" ];
  preferLocalBuild = true;
}