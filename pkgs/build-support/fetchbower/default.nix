{ stdenv, fetch-bower, git, cacert }: name: version: target: outputHash: stdenv.mkDerivation {
  name = "${name}-${version}";
  buildCommand = ''
    export GIT_SSL_CAINFO=${cacert}/etc/ssl/certs/ca-bundle.crt
    out=$PWD/out fetch-bower "${name}" "${version}" "${target}"
    cp -R out $out
  '';
  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  inherit outputHash;
  buildInputs = [git fetch-bower];
}
