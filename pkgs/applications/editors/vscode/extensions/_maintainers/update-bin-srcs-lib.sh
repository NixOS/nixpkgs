#!/usr/bin/env bash

prefetchExtensionZip() {
  declare publisher="${1?}"
  declare name="${2?}"
  declare version="${3?}"

  1>&2 echo
  1>&2 echo "------------- Downloading extension ---------------"

  declare extZipStoreName="${publisher}-${name}.zip"
  declare extUrl="https://${publisher}.gallery.vsassets.io/_apis/public/gallery/publisher/${publisher}/extension/${name}/${version}/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage";
  1>&2 echo "extUrl='$extUrl'"
  declare nixPrefetchArgs=( --name "$extZipStoreName" --print-path "$extUrl" )

  1>&2 printf "$ nix-prefetch-url"
  1>&2 printf " %q" "${nixPrefetchArgs[@]}"
  1>&2 printf " 2> /dev/null\n"
  declare zipShaWStorePath
  zipShaWStorePath=$(nix-prefetch-url "${nixPrefetchArgs[@]}" 2> /dev/null)

  1>&2 echo "zipShaWStorePath='$zipShaWStorePath'"
  echo "$zipShaWStorePath"
}


prefetchExtensionUnpacked() {
  declare publisher="${1?}"
  declare name="${2?}"
  declare version="${3?}"

  declare zipShaWStorePath
  zipShaWStorePath="$(prefetchExtensionZip "$publisher" "$name" "$version")"

  declare zipStorePath
  zipStorePath="$(echo "$zipShaWStorePath" | tail -n1)"
  1>&2 echo "zipStorePath='$zipStorePath'"

  function rm_tmpdir() {
    1>&2 printf "rm -rf %q\n" "$tmpDir"
    rm -rf "$tmpDir"
  }
  function make_trapped_tmpdir() {
    tmpDir=$(mktemp -d)
    trap rm_tmpdir EXIT
  }

  1>&2 echo
  1>&2 echo "------------- Unpacking extension ---------------"

  make_trapped_tmpdir
  declare unzipArgs=( -q -d "$tmpDir" "$zipStorePath" )
  1>&2 printf "$ unzip"
  1>&2 printf " %q" "${unzipArgs[@]}"
  1>&2 printf "\n"
  unzip "${unzipArgs[@]}"

  declare unpackedStoreName="${publisher}-${name}"

  declare unpackedStorePath
  unpackedStorePath="$(nix add-to-store -n "$unpackedStoreName" "$tmpDir")"
  declare unpackedSha256
  unpackedSha256="$(nix --extra-experimental-features nix-command hash path --base32 --type sha256 "$unpackedStorePath")"
  1>&2 echo "unpackedStorePath='$unpackedStorePath'"
  1>&2 echo "unpackedSha256='$unpackedSha256'"

  rm_tmpdir

  echo "$unpackedSha256"
  echo "$unpackedStorePath"
}


prefetchExtensionJson() {
  declare publisher="${1?}"
  declare name="${2?}"
  declare version="${3?}"

  declare unpackedShaWStorePath
  unpackedShaWStorePath="$(prefetchExtensionUnpacked "$publisher" "$name" "$version")"

  declare unpackedStorePath
  unpackedStorePath="$(echo "$unpackedShaWStorePath" | tail -n1)"
  1>&2 echo "unpackedStorePath='$unpackedStorePath'"

  declare jsonShaWStorePath
  jsonShaWStorePath=$(nix-prefetch-url --print-path "file://${unpackedStorePath}/extension/package.json" 2> /dev/null)

  1>&2 echo "jsonShaWStorePath='$jsonShaWStorePath'"
  echo "$jsonShaWStorePath"
}


formatExtRuntimeDeps() {
  declare publisher="${1?}"
  declare name="${2?}"
  declare version="${3?}"

  declare jsonShaWStorePath
  jsonShaWStorePath="$(prefetchExtensionJson "$publisher" "$name" "$version")"

  declare jsonStorePath
  jsonStorePath="$(echo "$jsonShaWStorePath" | tail -n1)"
  1>&2 echo "jsonStorePath='$jsonStorePath'"

  # Assume packages without an architectures are for x86_64 and remap arm64 to aarch64.
  declare jqQuery
  jqQuery=$(cat <<'EOF'
.runtimeDependencies
| map(select(.platforms[] | in({"linux": null, "darwin": null})))
| map(select(.architectures == null).architectures |= ["x86_64"])
| map(del(.architectures[] | select(. | in({"x86_64": null, "arm64": null}) | not)))
| map((.architectures[] | select(. == "arm64")) |= "aarch64")
| map(select(.architectures != []))
| .[] | {
  (.id + "__" + (.architectures[0]) + "-" + (.platforms[0])):
    {installPath, binaries, urls: [.url, .fallbackUrl] | map(select(. != null))}
}
EOF
)

  1>&2 printf "$ cat %q | jq '%s'\n" "$jsonStorePath" "$jqQuery"
  cat "$jsonStorePath" | jq "$jqQuery"
}


computeExtRtDepChecksum() {
  declare rtDepJsonObject="${1?}"
  declare url
  url="$(echo "$rtDepJsonObject" | jq -j '.[].urls[0]')"
  declare sha256
  1>&2 printf "$ nix-prefetch-url '%s'\n" "$url"
  sha256="$(nix-prefetch-url "$url")"
  1>&2 echo "$sha256"
  echo "$sha256"
}


computeAndAttachExtRtDepsChecksums() {
  while read -r rtDepJsonObject; do
    declare sha256
    sha256="$(computeExtRtDepChecksum "$rtDepJsonObject")"
    echo "$rtDepJsonObject" | jq --arg sha256 "$sha256" '.[].sha256 = $sha256'
  done < <(cat - | jq  -c '.')
}


jqStreamToJson() {
  cat - | jq --slurp '. | add'
}


jsonToNix() {
  # TODO: Replacing this non functional stuff with a proper json to nix
  # implementation would allow us to produce a 'rt-deps-bin-srcs.nix' file instead.
  false
  cat - | sed -E -e 's/": /" = /g' -e 's/,$/;/g' -e 's/  }$/  };/g'  -e 's/  ]$/  ];/g'
}
