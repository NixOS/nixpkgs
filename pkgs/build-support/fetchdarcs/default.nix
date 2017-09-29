{stdenv, darcs, nix, cacert}:

{url, rev ? null, context ? null, md5 ? "", sha256 ? ""}:

if md5 != "" then
  throw "fetchdarcs does not support md5 anymore, please use sha256"
else
stdenv.mkDerivation {
  name = "fetchdarcs";
  NIX_SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  builder = ./builder.sh;
  buildInputs = [darcs];

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  inherit url rev context;
}
