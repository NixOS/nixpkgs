#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq gnused nix

set -euo pipefail

ARCHS=(
  'linux-aarch_64'
  'linux-ppcle_64'
  'linux-s390_64'
  'linux-x86_32'
  'linux-x86_64'
  'osx-aarch_64'
  'osx-x86_64'
  'windows-x86_32'
  'windows-x86_64'
)
HASHES_FILE=pkgs/by-name/pr/protoc-gen-grpc-java/hashes.nix

version="$(
  curl --silent --location --fail \
    ${GITHUB_TOKEN:+-u ":${GITHUB_TOKEN}"} \
    https://api.github.com/repos/grpc/grpc-java/releases/latest |
    jq -r '.tag_name' |
    sed 's/^v//'
)"

echo '{' >"${HASHES_FILE}"
for arch in "${ARCHS[@]}"; do
  url="https://repo1.maven.org/maven2/io/grpc/protoc-gen-grpc-java/${version}/protoc-gen-grpc-java-${version}-${arch}.exe"
  hash=$(nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri "$(nix-prefetch-url "${url}")")
  echo "  ${arch} = \"${hash}\";" >>"${HASHES_FILE}"
done
echo '}' >>"${HASHES_FILE}"
