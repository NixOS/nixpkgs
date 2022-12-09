#!/usr/bin/env nix-shell
#! nix-shell -p coreutils -p jq -p unzip -i bash
set -euo pipefail

#
# A little script to help maintaining this package. It will:
#
#  -  download the specified version of the extension to the store and print its url, packed store path and hash
#  -  unpack the extension, bring it to the store and print its store path and hash
#  -  fetch its runtimes dependencies from the 'package.json' file using the 'jq' utility, unpack those to the store
#     and print its url store path and hash
#  -  patch elf of the binaries that got a nix replacement
#  -  bring the patched version to the store
#  -  run their '--version' and call 'ldd'
#  -  print the version of the runtime deps nix replacements.
#
# TODO: Print to a properly formated nix file all the required information to fetch everything (extension + runtime deps).
# TODO: Print x86 and maybe darwin runtime dependencies.
#

scriptDir=$(cd "`dirname "$0"`"; pwd)
echo "scriptDir='$scriptDir'"

extPublisher="vscode"
extName="cpptools"
defaultExtVersion="0.16.1"
extVersion="${1:-$defaultExtVersion}"

echo
echo "------------- Downloading extension ---------------"

extZipStoreName="${extPublisher}-${extName}.zip"
extUrl="https://ms-vscode.gallery.vsassets.io/_apis/public/gallery/publisher/ms-vscode/extension/cpptools/${extVersion}/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"
echo "extUrl='$extUrl'"
storePathWithSha=$(nix-prefetch-url --name "$extZipStoreName" --print-path "$extUrl" 2> /dev/null)

cpptoolsZipStorePath="$(echo "$storePathWithSha" | tail -n1)"
cpptoolsZipSha256="$(echo "$storePathWithSha" | head -n1)"
echo "cpptoolsZipStorePath='$cpptoolsZipStorePath'"
echo "cpptoolsZipSha256='$cpptoolsZipSha256'"


extStoreName="${extPublisher}-${extName}"


function rm_tmpdir() {
  rm -rf "$tmpDir"
}
function make_trapped_tmpdir() {
  tmpDir=$(mktemp -d)
  trap rm_tmpdir EXIT
}

echo
echo "------------- Unpacked extension ---------------"

make_trapped_tmpdir
unzip -q -d "$tmpDir" "$cpptoolsZipStorePath"

cpptoolsStorePath="$(nix add-to-store -n "$extStoreName" "$tmpDir")"
cpptoolsSha256="$(nix hash-path --base32 --type sha512 "$cpptoolsStorePath")"
echo "cpptoolsStorePath='$cpptoolsStorePath'"
echo "cpptoolsSha256='$cpptoolsSha256'"

rm_tmpdir

storePathWithSha=$(nix-prefetch-url --print-path "file://${cpptoolsStorePath}/extension/package.json" 2> /dev/null)

extPackageJSONStorePath="$(echo "$storePathWithSha" | tail -n1)"
extPackageJSONSha256="$(echo "$storePathWithSha" | head -n1)"
echo "extPackageJSONStorePath='$extPackageJSONStorePath'"
echo "extPackageJSONSha256='$extPackageJSONSha256'"

print_runtime_dep() {

  local outName="$1"
  local extPackageJSONStorePath="$2"
  local depDesc="$3"

  local urlRaw=$(cat "$extPackageJSONStorePath" | jq -r --arg desc "$depDesc" '.runtimeDependencies[] | select(.description == $desc) | .url')
  local url=$(echo $urlRaw | xargs curl -Ls -o /dev/null -w %{url_effective})

  local urlRawVarStr="${outName}_urlRaw='$urlRaw'"
  local urlVarStr="${outName}_url='$url'"
  echo "$urlRawVarStr"
  echo "$urlVarStr"

  local storePathWithSha="$(nix-prefetch-url --unpack --print-path "$url" 2> /dev/null)"

  local storePath="$(echo "$storePathWithSha" | tail -n1)"
  local sha256="$(echo "$storePathWithSha" | head -n1)"

  local sha256VarStr="${outName}_sha256='$sha256'"
  local storePathVarStr="${outName}_storePath='$storePath'"
  echo "$sha256VarStr"
  echo "$storePathVarStr"

  eval "$urlRawVarStr"
  eval "$urlVarStr"
  eval "$sha256VarStr"
  eval "$storePathVarStr"
}

echo
echo "------------- Runtime dependencies ---------------"

print_runtime_dep "langComponentBinaries" "$extPackageJSONStorePath" "C/C++ language components (Linux / x86_64)"
print_runtime_dep "monoRuntimeBinaries" "$extPackageJSONStorePath" "Mono Runtime (Linux / x86_64)"
print_runtime_dep "clanFormatBinaries" "$extPackageJSONStorePath" "ClangFormat (Linux / x86_64)"


echo
echo "------------- Runtime deps missing elf deps ---------------"

source "$scriptDir/missing_elf_deps.sh"

echo
echo "------------- Runtime dep mono ---------------"

make_trapped_tmpdir
find "$monoRuntimeBinaries_storePath" -mindepth 1 -maxdepth 1 | xargs -d '\n' cp -rp -t "$tmpDir"
chmod -R a+rwx "$tmpDir"

ls -la "$tmpDir/debugAdapters"

patchelf_mono "$tmpDir/debugAdapters/mono.linux-x86_64"

chmod a+x "$tmpDir/debugAdapters/mono.linux-x86_64"
ldd "$tmpDir/debugAdapters/mono.linux-x86_64"
"$tmpDir/debugAdapters/mono.linux-x86_64" --version

monoRuntimeBinariesPatched_storePath="$(nix add-to-store -n "monoRuntimeBinariesPatched" "$tmpDir")"
echo "monoRuntimeBinariesPatched_storePath='$monoRuntimeBinariesPatched_storePath'"

rm_tmpdir


echo
echo "------------- Runtime dep clang ---------------"
make_trapped_tmpdir
find "$clanFormatBinaries_storePath" -mindepth 1 -maxdepth 1 | xargs -d '\n' cp -rp -t "$tmpDir"
chmod -R a+rwx "$tmpDir"

ls -la "$tmpDir/bin"

patchelf_clangformat "$tmpDir/bin/clang-format"

chmod a+x "$tmpDir/bin/clang-format"
ldd "$tmpDir/bin/clang-format"
"$tmpDir/bin/clang-format" --version


clanFormatBinariesPatched_storePath="$(nix add-to-store -n "clanFormatBinariesPatched" "$tmpDir")"
echo "clanFormatBinariesPatched_storePath='$clanFormatBinariesPatched_storePath'"

rm_tmpdir

echo
echo "------------- Nix mono ---------------"
print_nix_version_clangtools

echo
echo "------------- Nix mono ---------------"
print_nix_version_mono

