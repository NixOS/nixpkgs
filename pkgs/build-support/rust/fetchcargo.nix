{ stdenv, cacert, git, cargo, rustRegistry }:
{ name ? "cargo-deps", src, srcs, sourceRoot, sha256, cargoUpdateHook ? "" }:

stdenv.mkDerivation {
  name = "${name}-fetch";
  buildInputs = [ cargo git ];
  inherit src srcs sourceRoot rustRegistry cargoUpdateHook;

  phases = "unpackPhase installPhase";

  installPhase = ''
    bash ${./fetch-cargo-deps} . "$out"
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  impureEnvVars = [ "http_proxy" "https_proxy" "ftp_proxy" "all_proxy" "no_proxy" ];
  preferLocalBuild = true;
}
