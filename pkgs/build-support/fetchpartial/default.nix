{ lib, stdenvNoCC, partialzip-rs, cacert }:

{ url, file, sha256 }:

 stdenvNoCC.mkDerivation {
  name = file;
  nativeBuildInputs = [ partialzip-rs ];

  buildCommand = ''
    partialzip download ${url} ${file} "$out"
  '';

  outputHashMode = "flat";
  outputHashAlgo = "sha256";
  outputHash = sha256;

  SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
}
