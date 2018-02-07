{ stdenv, jq }: { src, nodejs, sha256 }:

# Only npm >= 5.4.2 is deterministic, see:
# https://github.com/npm/npm/issues/17979#issuecomment-332701215
assert stdenv.lib.versionAtLeast nodejs.version "8.9.0";

stdenv.mkDerivation {
  name = "node_modules";

  outputHashAlgo = "sha256";
  outputHash = sha256;
  outputHashMode = "recursive";

  nativeBuildInputs = [ jq nodejs ];

  buildCommand = ''
    cp -r ${src}/* .
    HOME=. npm install --force --ignore-scripts --only=production
    for f in $(find node_modules -name package.json); do
      # https://github.com/npm/npm/issues/10393
      jq -S 'delpaths(keys | map(select(startswith("_")) | [.]))' $f > $f.tmp
      mv $f.tmp $f
    done
    mv node_modules $out
  '';
}
