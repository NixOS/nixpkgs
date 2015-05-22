{ stdenv, cacert, git, rustc, cargo, rustRegistry }:
{ name ? "cargo-deps", src, sha256, cargoUpdateHook ? "" }:

stdenv.mkDerivation {
  name = "${name}-fetch";
  buildInputs = [ rustc cargo git ];
  builder = ./fetch-builder.sh;
  fetcher = ./fetch-cargo-deps;
  inherit src rustRegistry cargoUpdateHook;

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  SSL_CERT_FILE = "${cacert}/etc/ca-bundle.crt";

  impureEnvVars = [ "http_proxy" "https_proxy" "ftp_proxy" "all_proxy" "no_proxy" ];
  preferLocalBuild = true;
}
