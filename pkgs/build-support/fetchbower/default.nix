{ stdenv, fetch-bower, git }: name: version: target: outputHash: stdenv.mkDerivation {
  name = "${name}-${version}";
  buildCommand = ''
    out=$PWD/out fetch-bower "${name}" "${version}" "${target}"
    cp -R out $out
  '';
  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  inherit outputHash;
  buildInputs = [git fetch-bower];
}
