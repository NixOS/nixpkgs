{ stdenv, cacert, git, rustc, cargo, rustRegistry }:
{ name ? "cargo-deps", src, srcs, sourceRoot, sha256, cargoUpdateHook ? "" }:

stdenv.mkDerivation {
  name = "${name}-fetch";
  buildInputs = [ rustc cargo git ];
  inherit src srcs sourceRoot rustRegistry cargoUpdateHook;

  phases = "unpackPhase installPhase";

  installPhase = ''
    bash ${./fetch-cargo-deps} . "$out"
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  impureEnvVars = [ "http_proxy" "https_proxy" "ftp_proxy" "all_proxy" "no_proxy" ];
  preferLocalBuild = true;
}
