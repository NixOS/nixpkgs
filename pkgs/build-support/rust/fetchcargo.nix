{ stdenv, cacert, git, rust, rustRegistry }:
{ name ? "cargo-deps", src, srcs, sourceRoot, sha256, cargoUpdateHook ? "" }:

stdenv.mkDerivation {
  name = "${name}-fetch";
  buildInputs = [ rust.cargo rust.rustc git ];
  inherit src srcs sourceRoot rustRegistry cargoUpdateHook;

  phases = "unpackPhase installPhase";

  installPhase = ''
    source ${./fetch-cargo-deps}

    export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt

    fetchCargoDeps . "$out"
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  impureEnvVars = stdenv.lib.fetchers.proxyImpureEnvVars;
  preferLocalBuild = true;
}
